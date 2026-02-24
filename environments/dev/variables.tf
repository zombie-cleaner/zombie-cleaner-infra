# global configurations =======================================================================
variable "globalConfigs" {
  type = object({
    region      = string,
    environment = string,
    appName     = string
  })
}

# remotestate configurations =======================================================================
variable "remoteStateConfigs" {
  type = object({
    bucket = string
    key    = string
  })
}

# Compute related services ========================================================================

# Lambda
# variable lambda_functions {
#     type = map(object({
#             bucket_name = string
#             versioning = optional(bool, false)
#             tags = optional(map(string), {}) 
#         }))
#     }


# storage related services =======================================================================

# S3
variable "platformAccessPolicyBucket" {
  type = object({
    bucket = string
  })
}
# RDS
variable "rdsDefaultDBConfigs" {
  type = object({
    databaseIdentifier = string
    databaseUsername   = string
    databasePassword   = string
  })
}
