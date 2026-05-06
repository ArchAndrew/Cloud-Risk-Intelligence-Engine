variable "environment" {
  description = "Environment name for the Machine-Lite deployment"
  type        = string
  default     = "dev"
}

variable "tf_state_bucket_name" {
  description = "Globally unique S3 bucket name used for Terraform remote state"
  type        = string
}

variable "alert_emails" {
  description = "Email addresses for budget alerts"
  type        = list(string)
}

variable "evidence_store_bucket_name" {
  description = "Globally unique S3 bucket name for Machine-Lite security evidence storage"
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
  description = "Splunk index for Machine-Lite risk events"
  type        = string
  default     = "machine_lite"
}

variable "splunk_sourcetype" {
  description = "Splunk sourcetype for Machine-Lite risk events"
  type        = string
  default     = "aws:machine_lite:risk"
}