variable "platformAccessPolicyBucket" {
  type = string
}
variable "globalConfigs" {
  type = object({
    region           = string,
    environment      = string,
    appName          = string
    policiesLocation = string
  })
}
