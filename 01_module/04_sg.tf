resource "aws_security_group" "security_bastion" {
    name = "${format("%s-sg-bastion", var.name)}"
    description = "security group for bastion"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_bastion.description
            from_port = var.sg_bastion.from_port
            to_port = var.sg_bastion.to_port
            protocol = var.sg_bastion.protocol
            cidr_blocks = var.sg_bastion.cidr_blocks
            ipv6_cidr_blocks = var.sg_bastion.ipv6_cidr_blocks
            security_groups = []
            prefix_list_ids = []
            self = false
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
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-bastion", var.name)}"
    }
}

resource "aws_security_group" "security_alb" {
    name = "${format("%s-sg-alb", var.name)}"
    description = "security group for alb"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description      = "HTTP"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        },
        {
            description      = "HTTPS"
            from_port        = 443
            to_port          = 443
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
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
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-alb", var.name)}"
    }
}

resource "aws_security_group" "security_web" {
    name = "${format("%s-sg-web", var.name)}"
    description = "security group for web"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_web.0.description
            from_port = var.sg_web.0.from_port
            to_port = var.sg_web.0.to_port
            protocol = var.sg_web.0.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.security_bastion.id]
            prefix_list_ids = []
            self = false
        },
        {
            description = var.sg_web.1.description
            from_port = var.sg_web.1.from_port
            to_port = var.sg_web.1.to_port
            protocol = var.sg_web.1.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.security_alb.id]
            prefix_list_ids = []
            self = false
        },
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-web", var.name)}"
    }
}

resource "aws_security_group" "security_was" {
    name = "${format("%s-sg-was", var.name)}"
    description = "security group for was"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_was.0.description
            from_port = var.sg_was.0.from_port
            to_port = var.sg_was.0.to_port
            protocol = var.sg_was.0.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.security_bastion.id]
            prefix_list_ids = []
            self = false
        },
        {
            description = var.sg_was.1.description
            from_port = var.sg_was.1.from_port
            to_port = var.sg_was.1.to_port
            protocol = var.sg_was.1.protocol
            cidr_blocks = var.cidr.web
            ipv6_cidr_blocks = []
            security_groups = []
            prefix_list_ids = []
            self = false
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
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-was", var.name)}"
    }
}

resource "aws_security_group" "security_db" {
    name = "${format("%s-sg-db", var.name)}"
    description = "security group for db"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_db.description
            from_port = var.sg_db.from_port
            to_port = var.sg_db.to_port
            protocol = var.sg_db.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.security_was.id]
            prefix_list_ids = []
            self = false
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
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-db", var.name)}"
    }
}

resource "aws_security_group" "security_efs" {
    name = "${format("%s-sg-efs", var.name)}"
    description = "security group for efs"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = "NFS"
            from_port = "2049"
            to_port = "2049"
            protocol = "tcp"
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.security_was.id]
            prefix_list_ids = []
            self = false
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
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-efs", var.name)}"
    }
}





/*
resource "aws_security_group" "security_ansible" {
  name        = "cd-sg-ansible"
  description = "security group for ansible"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "icmp"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = false
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
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    }
  ]

  tags = {
    Name = "cd-sg-ansible"
  }
}
*/
