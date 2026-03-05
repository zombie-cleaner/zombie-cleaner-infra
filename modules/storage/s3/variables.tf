variable "globalConfigs" {
  type = object({
    region           = string,
    environment      = string,
    appName          = string
    policiesLocation = string
  })
}

variable "platformAccessPolicyBucket" {
  type = object({
    bucket     = string
    policyFile = string
  })
}
