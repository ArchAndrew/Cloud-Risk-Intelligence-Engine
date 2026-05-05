resource "aws_s3_bucket" "evidence_store" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-evidence-store"
    Purpose     = "security-evidence-storage"
    DataClass   = "security-logs"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "evidence_store_versioning" {
  bucket = aws_s3_bucket.evidence_store.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence_store_encryption" {
  bucket = aws_s3_bucket.evidence_store.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "evidence_store_public_access_block" {
  bucket = aws_s3_bucket.evidence_store.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}