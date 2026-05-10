resource "aws_lambda_function" "risk_engine" {
  function_name = "${var.project_name}-${var.environment}-risk-engine"

  role    = var.lambda_execution_role_arn
  handler = "app.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.lambda_risk_engine_zip.output_path
  source_code_hash = data.archive_file.lambda_risk_engine_zip.output_base64sha256

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      ENVIRONMENT           = var.environment
      EVIDENCE_STORE_BUCKET = var.evidence_store_bucket_name
      PROJECT_NAME          = var.project_name
      BEDROCK_MODEL_ID      = var.bedrock_model_id
      APPROVAL_TOPIC_ARN    = var.approval_topic_arn
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-risk-engine"
    Purpose = "risk-scoring-and-classification"
  }
}