module "backend_bootstrap" {
  source = "../../modules/backend-bootstrap"

  bucket_name = var.tf_state_bucket_name
  environment = var.environment
}

module "budget_alerts" {
  source = "../../modules/budget-alerts"

  project_name         = "machine-lite"
  environment          = var.environment
  monthly_budget_limit = "50"
  alert_emails         = var.alert_emails
}

module "s3_evidence_store" {
  source = "../../modules/s3-evidence-store"

  bucket_name  = var.evidence_store_bucket_name
  project_name = "machine-lite"
  environment  = var.environment
}

module "iam" {
  source = "../../modules/iam"

  project_name              = "machine-lite"
  environment               = var.environment
  evidence_store_bucket_arn = module.s3_evidence_store.bucket_arn
}

module "lambda_normalizer" {
  source = "../../modules/lambda-normalizer"

  project_name               = "machine-lite"
  environment                = var.environment
  source_dir                 = "../../../src/normalizer"
  lambda_execution_role_arn  = module.iam.lambda_execution_role_arn
  evidence_store_bucket_name = var.evidence_store_bucket_name
}