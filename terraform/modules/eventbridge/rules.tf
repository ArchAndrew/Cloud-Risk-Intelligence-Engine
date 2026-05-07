#This rule listens for Machine-Lite security events and prepares them to route into the normalizer.
resource "aws_cloudwatch_event_rule" "security_finding_rule" {
  name           = "${var.project_name}-${var.environment}-security-finding-rule"
  description    = "Routes Machine-Lite security findings to the normalizer Lambda"
  event_bus_name = aws_cloudwatch_event_bus.machine_lite_bus.name

  event_pattern = jsonencode({
    source = [
      "machine-lite.security"
    ]

    detail-type = [
      "Security Finding"
    ]
  })

  tags = {
    Name    = "${var.project_name}-${var.environment}-security-finding-rule"
    Purpose = "route-security-findings"
  }
}