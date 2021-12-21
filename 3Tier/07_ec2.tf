resource "aws_instance" "web" {
  ami = "ami-0263588f2531a56bd"
  instance_type = "t2.micro"
  key_name = "id_rsa"
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  availability_zone = "ap-northeast-2a"
  private_ip = "192.168.2.11"
  iam_instance_profile = aws_iam_instance_profile.profile_web.name
  subnet_id = aws_subnet.cd_priweb1.id
  user_data =<<-EOF
  #!/bin/bash
  sudo su -
  sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
  systemctl restart sshd
  EOF
  
  tags = {
    "Name" = "cd-web"
  }
}

resource "aws_iam_instance_profile" "profile_web" {
  name = "profile-web"
  role = aws_iam_role.role_web.name
}

resource "aws_iam_role" "role_web" {
  name = "role-web"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy_web" {
  name = "policy-web"
  role = aws_iam_role.role_web.id

  policy = <<END
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListObject",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.cd_log_bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.cd_log_bucket.arn}/*"
            ]
        }
    ]
}
END
}


resource "aws_instance" "was" {
  ami = "ami-0263588f2531a56bd"
  instance_type = "t3.medium"
  key_name = "id_rsa"
  vpc_security_group_ids = [aws_security_group.sg_was.id]
  availability_zone = "ap-northeast-2a"
  private_ip = "192.168.4.11"
  subnet_id = aws_subnet.cd_priwas1.id
  user_data =<<-EOF
  #!/bin/bash
  sudo su -
  sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
  systemctl restart sshd
  EOF
  tags = {
    "Name" = "cd-was"
  }
}