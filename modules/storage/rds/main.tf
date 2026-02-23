resource "aws_db_instance" "java_fall_sprint_db" {
  identifier = "${var.rdsDefaultDBConfigs.databaseIdentifier}-${var.globalConfigs.environment}-${var.globalConfigs.appName}"

  engine            = "mysql"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_encrypted = true

  username              = var.rdsDefaultDBConfigs.databaseUsername
  password              = var.rdsDefaultDBConfigs.databasePassword
  max_allocated_storage = 22
  apply_immediately     = false

  skip_final_snapshot = true
}
