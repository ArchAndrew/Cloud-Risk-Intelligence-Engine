variable "project_name" {
  description = "Project name for tagging and naming resources"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD"
  type        = string
  default     = "50"
}

variable "alert_emails" {
  description = "List of email addresses to receive budget alerts"
  type        = list(string)
}