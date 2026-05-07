#Bucket name MUST be globally unique. Bucket name referenced in .tfvars
module "backend_bootstrap" {
  source = "../../modules/backend-bootstrap"

  bucket_name = var.tf_state_bucket_name
  environment = var.environment
}

#Adds cost governance layer

module "budget_alerts" {
  source = "../../modules/budget-alerts"

  project_name         = "machine-lite"
  environment          = var.environment
  monthly_budget_limit = "50"
  alert_emails         = var.alert_emails
}

##Evidence storage layer: persists security data for audit, analysis, and compliance retention
module "s3_evidence_store" {
  source = "../../modules/s3-evidence-store"

  bucket_name  = var.evidence_store_bucket_name
  project_name = "machine-lite"
  environment  = var.environment
}

#This creates the Lambda execution role and grants it least-privilege access to the evidence store.
module "iam" {
  source = "../../modules/iam"

  project_name              = "machine-lite"
  environment               = var.environment
  evidence_store_bucket_arn = module.s3_evidence_store.bucket_arn
}

##Normalization layer: processes and standardizes incoming security events for downstream analysis
module "lambda_normalizer" {
  source = "../../modules/lambda-normalizer"

  project_name               = "machine-lite"
  environment                = var.environment
  source_dir                 = "../../../src/normalizer"
  lambda_execution_role_arn  = module.iam.lambda_execution_role_arn
  evidence_store_bucket_name = var.evidence_store_bucket_name
  risk_engine_function_name  = module.lambda_risk_engine.lambda_risk_engine_name
}

#This creates your second Lambda: risk-engine.

#Risk engine layer: scores normalized security events and classifies business/security impact
module "lambda_risk_engine" {
  source = "../../modules/lambda-risk-engine"

  project_name               = "machine-lite"
  environment                = var.environment
  source_dir                 = "../../../src/risk_engine"
  lambda_execution_role_arn  = module.iam.lambda_execution_role_arn
  evidence_store_bucket_name = var.evidence_store_bucket_name
}

#Splunk forwarding layer: sends enriched risk results from S3 evidence store into Splunk HEC
module "splunk_forwarder" {
  source = "../../modules/splunk-forwarder"

  project_name              = "machine-lite"
  environment               = var.environment
  source_dir                = "${path.root}/../../../src/splunk_forwarder"
  lambda_execution_role_arn = module.iam.lambda_execution_role_arn

  evidence_store_bucket_name = module.s3_evidence_store.bucket_name
  evidence_store_bucket_arn  = module.s3_evidence_store.bucket_arn

  splunk_hec_url    = var.splunk_hec_url
  splunk_hec_token  = var.splunk_hec_token
  splunk_index      = var.splunk_index
  splunk_sourcetype = var.splunk_sourcetype
}

#EventBridge connected to Lambda (Normalizer) = pipeline trigger
module "eventbridge" {
  source = "../../modules/eventbridge"

  project_name = "machine-lite"
  environment  = var.environment

  lambda_normalizer_arn  = module.lambda_normalizer.lambda_normalizer_arn
  lambda_normalizer_name = module.lambda_normalizer.lambda_normalizer_name
}

#CloudTrail module enables centralized AWS audit logging
#for API activity, governance visibility, incident investigation,
#and evidence collection within the Machine-Lite pipeline.
module "cloudtrail" {
  source = "../../modules/cloudtrail"

  environment            = var.environment
  trail_name             = "machine-lite-${var.environment}-trail"
  cloudtrail_bucket_name = "machine-lite-cloudtrail-${var.environment}-finch"
}

#GuardDuty enables native AWS threat detection
#and continuous security finding generation
#for Machine-Lite detection analytics.
module "guardduty" {
  source = "../../modules/guardduty"

  environment = var.environment
}

#Security Hub module centralizes AWS security findings
#and compliance posture signals for governance reporting,
#control visibility, and Machine-Lite risk intelligence workflows.
module "securityhub" {
  source = "../../modules/securityhub"

  environment = var.environment
}

# SNS approval module enables human-in-the-loop review
# for high-risk findings before response, containment,
# or escalation workflows are triggered.
module "sns_approval" {
  source = "../../modules/sns-approval"

  environment  = var.environment
  alert_emails = var.alert_emails
}