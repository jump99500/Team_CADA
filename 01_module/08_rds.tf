resource "aws_db_instance" "database" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.23"
  instance_class    = "db.t3.micro"
  name              = "petclinic"
  identifier        = "cd"
  username          = "petclinic"
  password          = "petclinic"
  #parameter_group_name = "default.mysql8.0"
  #availability_zone = "ap-northeast-2a"
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids          = [aws_security_group.security_db.id]
  enabled_cloudwatch_logs_exports = ["error", "audit", "general", "slowquery"] #클라우드워치
  backup_window                   = "12:29-13:29"                              #백업
  backup_retention_period         = 4
  apply_immediately               = true
  skip_final_snapshot             = true
  tags = {
    "Name" = "cd-db"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "cd-dbsg"
  subnet_ids = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
}
