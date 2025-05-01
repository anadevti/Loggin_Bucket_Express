variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3 para armazenar logs do CloudTrail"
  default     = ""
}

variable "cloudtrail_id" {
  type        = string
  description = "Nome do CloudTrail"
  default     = "cloudtrail-logs"
}

variable "region" {
  type        = string
  description = "Região da AWS onde os recursos serão criados"
  default     = "sa-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags a serem aplicadas aos recursos"
  default     = {}
}

