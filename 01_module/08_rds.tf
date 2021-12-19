resource "aws_db_instance" "database" {
  allocated_storage    = var.database.allocated_storage
  storage_type         = var.database.storage_type
  engine               = var.database.engine
  engine_version       = var.database.engine_version
  instance_class       = var.database.instance_class
  multi_az             = var.database.multi_az
  name                 = var.database.name
  identifier           = format("%s-db", var.name)
  username             = var.database.username
  password             = var.database.password
  parameter_group_name = "default.mysql8.0"
  #availability_zone = "ap-northeast-2a"
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids          = [aws_security_group.security_db.id]
  enabled_cloudwatch_logs_exports = ["error", "audit", "general", "slowquery"] #클라우드워치
  backup_window                   = var.database.backup_window     #백업
  backup_retention_period         = 4
  apply_immediately               = true
  skip_final_snapshot             = true
  tags = {
    "Name" = "${format("%s-db", var.name)}"
  }
}
