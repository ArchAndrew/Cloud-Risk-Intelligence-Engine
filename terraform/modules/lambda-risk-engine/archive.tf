data "archive_file" "lambda_risk_engine_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/lambda-risk-engine.zip"
}