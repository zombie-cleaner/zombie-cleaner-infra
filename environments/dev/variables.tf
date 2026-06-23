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
variable "ec2Config" {
  description = "Configuration for the Spring Boot EC2 instance"
  type = object({
    instance_type     = string
    ssh_key_name      = string
    app_jar_s3_bucket = string
    app_jar_s3_key    = string
    java_version      = optional(string, "17")
    spring_boot_port  = optional(number, 8080)
    ssh_allowed_cidr  = optional(string, "0.0.0.0/0")
  })
}

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
