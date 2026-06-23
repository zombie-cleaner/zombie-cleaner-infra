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

# EC2 Instance
# module "ec2" {
#   source = "../../modules/compute/ec2"

#   # variables

#   # global configs
#   globalConfigs = var.globalConfigs

#   # ec2 configs
#   ec2Config = var.ec2Config
}

# lambda
module "lambda" {
  source = "../../modules/compute/lambda"

  # variables

  # global configs
  globalConfigs = var.globalConfigs
}

# miscellaneous
# event bridge
module "eventbridge" {
  # source
  source = "../../modules/miscellaneous/eventBridge"

  # variables
  # globals
  globalConfigs = var.globalConfigs

  # lambda information (arn) for target
  lambda_arns_for_eventbridge = module.lambda.lambda_arns_for_eventbridge
}

# Observability
# Cloudwatch 
module "cloudwatch" {
  # source
  source = "../../modules/observability/cloudwatch"

  # variables
  # globals 
  globalConfigs = var.globalConfigs

  # cloudwatch common configs
  cloudwatchCommonConfigs = var.cloudwatchCommonConfigs

  # lambda names 
  all_lambda_names = module.lambda.all_lambda_names
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
# module "rds" {
#   source = "../../modules/storage/rds"

#   rdsDefaultDBConfigs = var.rdsDefaultDBConfigs
#   globalConfigs       = var.globalConfigs
# }
