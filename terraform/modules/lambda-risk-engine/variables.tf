variable "project_name" {
  type    = string
  default = "machine-lite"
}

variable "environment" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "lambda_execution_role_arn" {
  type = string
}

variable "evidence_store_bucket_name" {
  type = string
}

variable "bedrock_model_id" {
  description = "Amazon Bedrock foundation model used for AI-assisted enrichment"
  type        = string
}

variable "approval_topic_arn" {
  description = "SNS topic ARN used for high-risk finding approval notifications"
  type        = string
}