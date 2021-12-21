#DB생성
resource "aws_db_instance" "cd_mydb" {
  allocated_storage               = 20
  storage_type                    = "gp2"
  engine                          = "mysql"
  engine_version                  = "8.0.23"
  instance_class                  = "db.t3.micro"
  name                            = "petclinic"
  identifier                      = "cd"
  username                        = "root"
  password                        = "petclinic"
  availability_zone               = "ap-northeast-2a"
  db_subnet_group_name            = aws_db_subnet_group.cd_dbsg.id
  vpc_security_group_ids          = [aws_security_group.sg_db.id]
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["error", "audit", "general", "slowquery"] #클라우드워치
  backup_window                   = "12:29-13:29"                              #백업
  backup_retention_period         = 4
  apply_immediately               = true
  tags = {
    "Name" = "cd-db"
  }
}
#DB서브넷 그룹
resource "aws_db_subnet_group" "cd_dbsg" {
  name       = "cd-dbsg"
  subnet_ids = [aws_subnet.cd_pridb1.id, aws_subnet.cd_pridb2.id]
}
