data "archive_file" "splunk_forwarder_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/splunk-forwarder.zip"
}