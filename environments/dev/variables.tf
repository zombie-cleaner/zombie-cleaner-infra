# global configurations =======================================================================
variable "globalConfigs" {
  type = object({
    region           = string
    environment      = string
    appName          = string
    policiesLocation = string
  })
}

# Compute related services ========================================================================

# EC2

# Lambda
# variable lambda_functions {
#     type = map(object({
#             bucket_name = string
#             versioning = optional(bool, false)
#             tags = optional(map(string), {}) 
#         }))
#     }

# observability 

# cloudwatch

variable "cloudwatchCommonConfigs" {
  type = object({
    retention_in_days = number
  })
}

# storage related services =======================================================================

# S3
variable "platformAccessPolicyBucket" {
  type = object({
    bucket     = string
    policyFile = string
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
