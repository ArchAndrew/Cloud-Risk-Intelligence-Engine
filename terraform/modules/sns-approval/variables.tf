variable "environment" {
  type = string
}

variable "alert_emails" {
  type = list(string)
}

variable "approval_handler_zip_path" {
  type = string
}