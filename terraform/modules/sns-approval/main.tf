# SNS approval module supports human-in-the-loop review
# for high-risk findings before response or escalation actions.

resource "aws_iam_role" "approval_handler_role" {
  name = "machine-lite-${var.environment}-approval-handler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "approval_handler_basic" {
  role       = aws_iam_role.approval_handler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "approval_handler_sns_publish" {
  name = "machine-lite-${var.environment}-approval-handler-sns-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.approval_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "approval_handler_sns_publish" {
  role       = aws_iam_role.approval_handler_role.name
  policy_arn = aws_iam_policy.approval_handler_sns_publish.arn
}

resource "aws_lambda_function" "approval_handler" {
  function_name = "machine-lite-${var.environment}-approval-handler"
  role          = aws_iam_role.approval_handler_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  filename      = var.approval_handler_zip_path
  timeout       = 30
  memory_size   = 256

  environment {
    variables = {
      APPROVAL_TOPIC_ARN = aws_sns_topic.approval_topic.arn
    }
  }

  tags = {
    Environment = var.environment
    Project     = "machine-lite"
    Purpose     = "human-approval-workflow"
  }
}