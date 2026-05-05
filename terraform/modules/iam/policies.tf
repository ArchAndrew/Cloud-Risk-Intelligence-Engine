resource "aws_iam_policy" "lambda_evidence_store_policy" {
  name        = "${var.project_name}-${var.environment}-lambda-evidence-store-policy"
  description = "Least-privilege access for Lambda functions to read and write Machine-Lite security evidence"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEvidenceStoreReadWrite"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]

        Resource = [
          var.evidence_store_bucket_arn,
          "${var.evidence_store_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_evidence_store_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_evidence_store_policy.arn
}