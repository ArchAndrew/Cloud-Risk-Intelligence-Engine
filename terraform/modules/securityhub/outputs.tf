output "securityhub_account_enabled" {
  value = aws_securityhub_account.machine_lite.id
}

output "aws_foundational_standard_subscription_arn" {
  value = aws_securityhub_standards_subscription.aws_foundational.standards_arn
}

