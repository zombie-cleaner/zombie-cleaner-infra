variable region {
  type        = string
  description = "region of aws resources"
}

variable lambda_functions {
  type = map(object({
            bucket_name = string
            versioning = optional(bool, false)
            tags = optional(map(string), {}) 
      }))
  }