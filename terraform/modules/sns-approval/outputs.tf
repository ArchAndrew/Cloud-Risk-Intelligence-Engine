output "approval_topic_arn" {
  value = aws_sns_topic.approval_topic.arn
}

output "approval_topic_name" {
  value = aws_sns_topic.approval_topic.name
}