#This creates the Lambda execution role and attaches basic CloudWatch Logs permissions.
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.project_name}-${var.environment}-lambda-execution-role"

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

  tags = {
    Name    = "${var.project_name}-${var.environment}-lambda-execution-role"
    Purpose = "machine-lite-serverless-execution"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# This inline policy grants the Lambda execution role permission to invoke
# Amazon Bedrock foundation models for AI-assisted risk analysis.
resource "aws_iam_role_policy" "lambda_bedrock_access" {
  name = "${var.project_name}-${var.environment}-lambda-bedrock-access"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBedrockInvokeModel"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      }
    ]
  })
}