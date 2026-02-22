variable "globalConfigs" {
  type = object({
    region      = string,
    environment = string,
    appName     = string
  })
}

variable "rdsDefaultDBConfigs" {
  type = object({
    databaseIdentifier = string
    databaseUsername   = string
    databasePassword   = string
  })
}