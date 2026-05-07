output "splunk_forwarder_name" {
  description = "Name of the Splunk forwarder Lambda"
  value       = aws_lambda_function.splunk_forwarder.function_name
}

output "splunk_forwarder_arn" {
  description = "ARN of the Splunk forwarder Lambda"
  value       = aws_lambda_function.splunk_forwarder.arn
}