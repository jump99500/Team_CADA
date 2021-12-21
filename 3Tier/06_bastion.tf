resource "aws_instance" "cd_bastion" {
  ami                    = "ami-0263588f2531a56bd"
  instance_type          = "t2.micro"
  key_name               = "id_rsa"
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  availability_zone      = "ap-northeast-2a"
  private_ip             = "192.168.0.11"
  subnet_id              = aws_subnet.cd_pub1.id
  iam_instance_profile = "ec2-cd"   #본인이 만든 role
  user_data              = file("./bastion_key.sh")

  depends_on = [
    time_sleep.wait_bastion
  ]

  tags = {
    "Name" = "cd-bastion"
  }
}

# Elastic IP 할당
resource "aws_eip" "cd_bastion_ip" {
  vpc        = true
  instance   = aws_instance.cd_bastion.id
  depends_on = [aws_internet_gateway.cd_ig]
}

output "bastion_public_ip" {
  value = aws_eip.cd_bastion_ip.public_ip
}
/*
data "aws_instance" "web" {
  instance_tags {
    Environment = "Name"
    instance    = "web"
  }
  instance_state_names = ["running"]
  depends_on = ["aws_autoscaling_group.cd_atsg"]
}

output "web_privateips" {
  value = data.aws_instance.web.private_ips
}
*/