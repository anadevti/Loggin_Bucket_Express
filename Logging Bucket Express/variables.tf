variable "bucket_name" {
  description = "Nome do bucket S3 para logs do CloudTrail"
  type        = string
  default     = "teste-s3-aninha-lab-2025"
}

variable "cloudtrail_id" {
  description = "ID do CloudTrail"
  type        = string 
  default     = "trail-logs-aninha-lab-2025"  
}

variable "region" {
  description = "Região AWS"
  type        = string
  default     = "sa-east-1"
  
}


variable "tags" {
  description = "Tags padrão para todos os recursos."
  type        = map(string)
  default     = {"Environment" = "Test",}
}
