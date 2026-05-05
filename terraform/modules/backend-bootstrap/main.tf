resource "aws_s3_bucket" "tf_state" {
bucket = var.bucket_name

tags = {
    Name        = "terraform-state-bucket"
    Environment = var.environment
    Project     = "machine-lite"
}
}

# Enable versioning (critical for state recovery)
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
bucket = aws_s3_bucket.tf_state.id

versioning_configuration {
    status = "Enabled"
}
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
bucket = aws_s3_bucket.tf_state.id

rule {
    apply_server_side_encryption_by_default {
    sse_algorithm = "AES256"
    }
}
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "tf_state_block" {
bucket = aws_s3_bucket.tf_state.id

block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}

# Optional lifecycle (cleanup old versions)
resource "aws_s3_bucket_lifecycle_configuration" "tf_state_lifecycle" {
bucket = aws_s3_bucket.tf_state.id

rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

filter {}

    noncurrent_version_expiration {
    noncurrent_days = 30
    }
}
}