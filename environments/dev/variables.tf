variable "region" {
  type        = string
  description = "region of aws resources"
}

# variable lambda_functions {
#     type = map(object({
#             bucket_name = string
#             versioning = optional(bool, false)
#             tags = optional(map(string), {}) 
#         }))
#     }

# variable "remote_backend" {
#     type = object({
#       s3_bucket_name = string
#       object_key_path = string
#     })
# }

variable "rds_db_database_identifier" {
  description = "rds database name"
}
variable "rds_db_username" {
  description = "username"
}
variable "rds_db_password" {
  description = "database password"
}
