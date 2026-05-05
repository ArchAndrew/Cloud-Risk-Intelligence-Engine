data "archive_file" "lambda_normalizer_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/lambda-normalizer.zip"
}