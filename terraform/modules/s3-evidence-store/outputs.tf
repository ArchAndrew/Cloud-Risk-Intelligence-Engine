output "bucket_name" {
  description = "Name of the S3 evidence store bucket"
  value       = aws_s3_bucket.evidence_store.id
}

output "bucket_arn" {
  description = "ARN of the S3 evidence store bucket"
  value       = aws_s3_bucket.evidence_store.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 evidence store bucket"
  value       = aws_s3_bucket.evidence_store.bucket_domain_name
}