resource "aws_cloudwatch_event_bus" "machine_lite_bus" {
  name = "${var.project_name}-${var.environment}-event-bus"

  tags = {
    Name    = "${var.project_name}-${var.environment}-event-bus"
    Purpose = "machine-lite-security-event-routing"
  }
}