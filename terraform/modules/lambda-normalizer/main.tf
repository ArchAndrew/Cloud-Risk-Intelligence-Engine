resource "aws_lambda_function" "normalizer" {
  function_name = "${var.project_name}-${var.environment}-normalizer"

  role    = var.lambda_execution_role_arn
  handler = "app.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.lambda_normalizer_zip.output_path
  source_code_hash = data.archive_file.lambda_normalizer_zip.output_base64sha256

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      ENVIRONMENT           = var.environment
      EVIDENCE_STORE_BUCKET = var.evidence_store_bucket_name
      PROJECT_NAME          = var.project_name
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-normalizer"
    Purpose = "normalize-security-events"
  }
}