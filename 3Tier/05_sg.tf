resource "aws_security_group" "sg_bastion" {
  name        = "cd-sg-bastion"
  description = "sg for bastion"
  vpc_id      = aws_vpc.cd_vpc.id

  ingress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "cd-sg-bastion"
  }
}

resource "aws_security_group" "sg_web" {
  name        = "cd-sg-web"
  description = "sg for web"
  vpc_id      = aws_vpc.cd_vpc.id

  ingress = [
    {
      description      = "ssh-bastion"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_bastion.id]
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "web"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_alb.id]
      prefix_list_ids  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "cd-sg-web"
  }
}

resource "aws_security_group" "sg_was" {
  name        = "cd-sg-was"
  description = "sg for was"
  vpc_id      = aws_vpc.cd_vpc.id

  ingress = [
    {
      description      = "ssh-bastion"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_bastion.id]
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "tomcat"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "web"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "cd-sg-was"
  }
}

resource "aws_security_group" "sg_alb" {
  name        = "cd-sg-alb"
  description = "sg for alb"
  vpc_id      = aws_vpc.cd_vpc.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "tomcat"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "cd-sg-alb"
  }
}

resource "aws_security_group" "sg_db" {
  name        = "cd-sg-db"
  description = "sg for db"
  vpc_id      = aws_vpc.cd_vpc.id

  ingress = [
    {
      description      = "MySQL"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_was.id]
      prefix_list_ids  = null
      self             = null
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "cd-sg-db"
  }
}

resource "aws_security_group" "sg_efs" {
    name = "cd-sg-efs"
    description = "security group for efs"
    vpc_id = aws_vpc.cd_vpc.id

    ingress = [
        {
            description = "NFS"
            from_port = "2049"
            to_port = "2049"
            protocol = "tcp"
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_was.id]
            prefix_list_ids = null
            self = null
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = null
            prefix_list_ids = null
            self = false
        }
    ]

    tags = {
        Name = "cd-sg-efs"
    }
}