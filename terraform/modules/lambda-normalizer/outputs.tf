#lambda_normalizer_name is used by lambda permission (invoke)
output "lambda_normalizer_name" {
  description = "Name of the Lambda normalizer function"
  value       = aws_lambda_function.normalizer.function_name
}

#lambda_normalizer_arn is used by EventBridge target
output "lambda_normalizer_arn" {
  description = "ARN of the Lambda normalizer function"
  value       = aws_lambda_function.normalizer.arn
}