variable "bucket_name" {
  description = "Globally unique S3 bucket name for the evidence store"
  type        = string
}

variable "project_name" {
  description = "Project name for consistent resource naming and tagging"
  type        = string
  default     = "machine-lite"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}