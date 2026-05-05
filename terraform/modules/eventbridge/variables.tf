variable "project_name" {
  description = "Project name for consistent resource naming"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}

variable "lambda_normalizer_arn" {
  description = "ARN of the Lambda function that normalizes incoming security events"
  type        = string
}

variable "lambda_normalizer_name" {
  description = "Name of the Lambda function for EventBridge invocation permission"
  type        = string
}