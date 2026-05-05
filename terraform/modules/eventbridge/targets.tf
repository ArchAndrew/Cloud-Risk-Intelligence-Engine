resource "aws_cloudwatch_event_target" "security_finding_target" {
  rule           = aws_cloudwatch_event_rule.security_finding_rule.name
  event_bus_name = aws_cloudwatch_event_bus.machine_lite_bus.name
  target_id      = "lambda-normalizer-target"

  arn = var.lambda_normalizer_arn
}

resource "aws_lambda_permission" "allow_eventbridge_to_invoke_normalizer" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_normalizer_name
  principal     = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.security_finding_rule.arn
}