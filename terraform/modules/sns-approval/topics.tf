resource "aws_sns_topic" "approval_topic" {
  name = "machine-lite-${var.environment}-approval-topic"

  tags = {
    Environment = var.environment
    Project     = "machine-lite"
    Purpose     = "human-approval-workflow"
  }
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.alert_emails)

  topic_arn = aws_sns_topic.approval_topic.arn
  protocol  = "email"
  endpoint  = each.value
}