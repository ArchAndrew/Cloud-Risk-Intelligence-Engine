terraform {
  backend "s3" {
    bucket       = "machine-lite-tfstate-finch"
    key          = "machine-lite/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}