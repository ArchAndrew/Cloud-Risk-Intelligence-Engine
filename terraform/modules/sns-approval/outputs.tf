output "approval_topic_arn" {
  value = aws_sns_topic.approval_topic.arn
}

output "approval_topic_name" {
  value = aws_sns_topic.approval_topic.name
}

output "approval_handler_function_name" {
  value = aws_lambda_function.approval_handler.function_name
}

output "approval_handler_function_arn" {
  value = aws_lambda_function.approval_handler.arn
}

