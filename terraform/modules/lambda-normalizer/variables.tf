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

variable "risk_engine_function_name" {
  description = "Name of the Lambda risk engine function invoked by the normalizer"
  type        = string
}

variable "evidence_bucket_name" {
  description = "S3 evidence bucket name for normalized findings"
  type        = string
}