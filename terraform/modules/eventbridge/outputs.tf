output "event_bus_name" {
  description = "Name of the Machine-Lite EventBridge bus"
  value       = aws_cloudwatch_event_bus.machine_lite_bus.name
}

output "event_bus_arn" {
  description = "ARN of the Machine-Lite EventBridge bus"
  value       = aws_cloudwatch_event_bus.machine_lite_bus.arn
}

output "security_finding_rule_name" {
  description = "Name of the security finding EventBridge rule"
  value       = aws_cloudwatch_event_rule.security_finding_rule.name
}

output "security_finding_rule_arn" {
  description = "ARN of the security finding EventBridge rule"
  value       = aws_cloudwatch_event_rule.security_finding_rule.arn
}