resource "aws_db_instance" "java_fall_sprint_db" {
  identifier = var.rds_db_database_identifier

  engine            = "mysql"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_encrypted = true

  username              = var.rds_db_username
  password              = var.rds_db_password
  max_allocated_storage = 22
  apply_immediately     = false

  skip_final_snapshot = true
}
