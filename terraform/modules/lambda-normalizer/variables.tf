variable "project_name" {
  description = "Project name for consistent resource naming"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}

variable "source_dir" {
  description = "Path to the Lambda source code directory"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "ARN of the IAM role used by the Lambda function"
  type        = string
}

variable "evidence_store_bucket_name" {
  description = "Name of the S3 bucket used to store normalized security evidence"
  type        = string
}