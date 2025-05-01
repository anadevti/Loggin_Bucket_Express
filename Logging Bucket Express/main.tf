provider "aws" {
  region = var.region
}

######################
# Dados auxiliares
######################
data "aws_caller_identity" "current" {}

######################
# KMS – chave gerenciada
######################
resource "aws_kms_key" "this" {
  description         = "KMS key for CloudTrail logs"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms_combined.json
  tags                = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail-logs"
  target_key_id = aws_kms_key.this.id
}

######################
# S3 – bucket versionado e cifrado
######################
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name != "" ? var.bucket_name : "cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

######################
# CloudTrail
######################
resource "aws_cloudtrail" "this" {
  name                          = var.cloudtrail_id
  s3_bucket_name                = aws_s3_bucket.this.id
  kms_key_id                    = aws_kms_key.this.arn
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  include_global_service_events = true
}

######################
# S3 Bucket Policy
######################
data "aws_iam_policy_document" "bucket_policy" {
  # CloudTrail valida ACL e região do bucket
  statement {
    sid = "CloudTrailGet"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.this.arn]
  }

  # CloudTrail grava objetos no bucket
  statement {
    sid = "CloudTrailPut"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  # Exigir TLS 1.2
  statement {
    sid    = "EnforceTLS12"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

######################
# KMS Policy – CloudTrail
######################
data "aws_iam_policy_document" "kms_root" {
  statement {
    sid    = "EnableRootAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_cloudtrail" {
  statement {
    sid    = "AllowCloudTrail"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_root.json,
    data.aws_iam_policy_document.kms_cloudtrail.json
  ]
}

######################
# Outputs
######################
output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}