variable "project_name" {
  description = "Project name for consistent resource naming"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "source_dir" {
  description = "Path to the Splunk forwarder Lambda source code"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role"
  type        = string
}

variable "splunk_hec_url" {
  description = "Splunk HEC endpoint URL"
  type        = string
}

variable "splunk_hec_token" {
  description = "Splunk HEC token"
  type        = string
  sensitive   = true
}

variable "splunk_index" {
  description = "Splunk index for Machine-Lite risk results"
  type        = string
  default     = "machine_lite"
}

variable "splunk_sourcetype" {
  description = "Splunk sourcetype for Machine-Lite risk events"
  type        = string
  default     = "aws:machine_lite:risk"
}

variable "evidence_store_bucket_name" {
  description = "Name of the S3 evidence store bucket"
  type        = string
}

variable "evidence_store_bucket_arn" {
  description = "ARN of the S3 evidence store bucket"
  type        = string
}