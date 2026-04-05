variable "globalConfigs" {
  type = object({
    region           = string
    environment      = string
    appName          = string
    policiesLocation = string
  })
}

variable "lambda_arns_for_eventbridge" {
  description = "Lambda ARNs for EventBridge"
  type        = map(string)
}
