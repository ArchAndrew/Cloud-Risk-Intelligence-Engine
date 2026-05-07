resource "aws_guardduty_detector" "machine_lite" {
  enable = true

  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = {
    Environment = var.environment
    Project     = "machine-lite"
    Purpose     = "threat-detection"
  }
}