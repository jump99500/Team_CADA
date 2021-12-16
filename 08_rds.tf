resource "aws_db_instance" "database" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    name = "petclinic"
    identifier = "mydb"
    username = "petclinic"
    password = "12341234"
    parameter_group_name = "default.mysql8.0"
    #availability_zone = "ap-northeast-2a"
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
    vpc_security_group_ids = [aws_security_group.security_db.id]
    skip_final_snapshot = true
    tags = {
        "Name"= "cd-db"
    }
}