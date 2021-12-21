module "test" {
  source = "../01_module"
  name   = "cd"
  key = {
    name    = "id_rsa"
    public  = file("./id_rsa.pub")
    private = file("./id_rsa")
  }
  region = {
    region = "ap-northeast-2"
    az     = ["a", "c"]
  }
  cidr = {
    vpc = "192.168.0.0/16"
    pub = ["192.168.0.0/24", "192.168.1.0/24"]
    web = ["192.168.2.0/24", "192.168.3.0/24"]
    was = ["192.168.4.0/24", "192.168.5.0/24"]
    db  = ["192.168.6.0/24", "192.168.7.0/24"]
  }
  sg_bastion = {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  sg_web = [
    {
      description = "SSH-bastion"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    }
  ]
  sg_was = [
    {
      description = "SSH-bastion"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    },
    {
      description = "Tomcat"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
    }
  ]
  sg_db = {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  bastion = {
    ami           = "ami-0263588f2531a56bd"
    instance_type = "t2.micro"
  }
  web = {
    count         = 2
    ami           = "ami-0263588f2531a56bd"
    instance_type = "t2.micro"
  }
  was = {
    count         = 2
    ami           = "ami-0263588f2531a56bd"
    instance_type = "t3.medium"
  }
  nlb = {
    port     = 8080
    protocol = "TCP"
  }
  database = {
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "8.0.23"
    instance_class       = "db.t3.micro"
    multi_az             = "true"
    name                 = "petclinic"
    username             = "root"
    password             = "petclinic"
    backup_window        = "12:29-13:29"
    storage_type         = "gp2"
  }

  lacf_web = {
    instance_type = "t2.micro"

  }
  lacf_was = {
    instance_type = "t2.medium"

  }


  atsg_web = {
    min_size                  = 2
    max_size                  = 10
    health_check_grace_period = 60
    health_check_type         = "EC2"
    desired_capacity          = 2
  }

  atsg_was = {
    min_size                  = 2
    max_size                  = 10
    health_check_grace_period = 60
    health_check_type         = "EC2"
    desired_capacity          = 2
  }


  backup = {
    interval      = 8
    interval_unit = "HOURS"
    times         = ["12:00"]
    count         = 10
  }
  lambda = {
    cw_s3  = "cw-s3"
    s3_ses = "s3-ses"
  }
}