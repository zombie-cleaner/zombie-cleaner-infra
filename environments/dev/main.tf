provider "aws"{
    region = var.region
}

# # remote backend configuration
# backend "remote_backend" {
    
# }


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
module "rds_instance" {
    source = "../../modules/storage/rds"

    rds_db_database_identifier  = var.rds_db_database_identifier
    rds_db_password = var.rds_db_password
    rds_db_username = var.rds_db_username
}