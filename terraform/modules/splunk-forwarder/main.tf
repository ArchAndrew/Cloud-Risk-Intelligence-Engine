resource "aws_lambda_function" "splunk_forwarder" {
  function_name = "${var.project_name}-${var.environment}-splunk-forwarder"

  role    = var.lambda_execution_role_arn
  handler = "app.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.splunk_forwarder_zip.output_path
  source_code_hash = data.archive_file.splunk_forwarder_zip.output_base64sha256

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      ENVIRONMENT       = var.environment
      PROJECT_NAME      = var.project_name
      SPLUNK_HEC_URL    = var.splunk_hec_url
      SPLUNK_HEC_TOKEN  = var.splunk_hec_token
      SPLUNK_INDEX      = var.splunk_index
      SPLUNK_SOURCETYPE = var.splunk_sourcetype
    }
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-splunk-forwarder"
    Purpose = "forward-risk-results-to-splunk"
  }
}

resource "aws_lambda_permission" "allow_s3_to_invoke_splunk_forwarder" {
  statement_id  = "AllowExecutionFromS3EvidenceStore"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.splunk_forwarder.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.evidence_store_bucket_arn
}

resource "aws_s3_bucket_notification" "evidence_store_notification" {
  bucket = var.evidence_store_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.splunk_forwarder.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "risk-results/"
    filter_suffix       = ".json"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_to_invoke_splunk_forwarder
  ]
}