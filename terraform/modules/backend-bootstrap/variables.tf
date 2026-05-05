variable "bucket_name" {
description = "Name of the S3 bucket for Terraform state"
type        = string
}

variable "environment" {
description = "Environment name (dev, prod, etc.)"
type        = string
default     = "dev"
}