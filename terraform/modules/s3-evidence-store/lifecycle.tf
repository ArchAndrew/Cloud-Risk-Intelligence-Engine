resource "aws_s3_bucket_lifecycle_configuration" "evidence_store_lifecycle" {
  bucket = aws_s3_bucket.evidence_store.id

  rule {
    id     = "transition-and-retain-security-data"
    status = "Enabled"

    filter {}

    # Transition older objects to cheaper storage
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Retain for audit, then expire
    expiration {
      days = 365
    }

    # Clean up old versions
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}