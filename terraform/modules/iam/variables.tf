variable "project_name" {
  description = "Project name for consistent resource naming"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}

variable "evidence_store_bucket_arn" {
  description = "ARN of the S3 evidence store bucket"
  type        = string
}