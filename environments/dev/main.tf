# global configurations 
provider "aws" {
  region = var.globalConfigs.region
}

# remote backend configuration
terraform {
  backend "s3" {
    bucket       = "state-backend-at-s3"
    key          = "env/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

# Compute module 
# lambda
module "lambda" {
  source = "../../modules/compute/lambda"

  # variables

  # global configs

}

# Security and governance
# Iam 
module "iam" {
  # source
  source = "../../modules/securityAndGovernance/iam"

  # variables
  # globals 
  globalConfigs              = var.globalConfigs
  platformAccessPolicyBucket = module.s3_buckets.platformAccessBucketName
}

# s3 buckets module 
module "s3_buckets" {
  # path
  source = "../../modules/storage/s3"

  # region of aws resources 
  globalConfigs              = var.globalConfigs
  platformAccessPolicyBucket = var.platformAccessPolicyBucket
}

# RDS instance
module "rds" {
  source = "../../modules/storage/rds"

  rdsDefaultDBConfigs = var.rdsDefaultDBConfigs
  globalConfigs       = var.globalConfigs
}
