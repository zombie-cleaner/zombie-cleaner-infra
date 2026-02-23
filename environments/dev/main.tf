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
module "lambda"{
  source = "../../modules/compute/lambda"

  # variables

  # global configs
  
}

# # s3 buckets module 
# module "s3_buckets" {
#     # path
#     source = "../../modules/storage/s3"

#     # Environment variables 

#     # map of lambda functions 
#     lambda_functions = var.lambda_functions

#     # region of aws resources 
#     region = var.region
# }

# RDS instance
module "rds" {
  source = "../../modules/storage/rds"

  rdsDefaultDBConfigs = var.rdsDefaultDBConfigs
  globalConfigs       = var.globalConfigs
}
