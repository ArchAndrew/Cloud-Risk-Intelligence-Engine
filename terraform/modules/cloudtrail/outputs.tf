output "cloudtrail_name" {
  value = aws_cloudtrail.machine_lite.name
}

output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}

output "cloudtrail_bucket_arn" {
  value = aws_s3_bucket.cloudtrail_logs.arn
}