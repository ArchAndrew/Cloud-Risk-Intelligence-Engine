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