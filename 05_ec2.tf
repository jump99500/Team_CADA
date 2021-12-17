resource "aws_instance" "bastion" {
  ami                    = "ami-0263588f2531a56bd"    #리눅스 18.04
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.id_rsa.id
  vpc_security_group_ids = [aws_security_group.security_bastion.id]
  availability_zone      = "ap-northeast-2a"
  private_ip             = "192.168.0.10" #하도 오류가 많이 나서 일단 주석처리 -> 근데 본인 마음대로 하면 됨
  subnet_id = aws_subnet.pub_1.id
  user_data              = file("./webserver.sh")
  tags = {
    "Name" = "cd-bastion"
  }
}

resource "aws_eip" "eip_bastion" {
  vpc      = true
  instance = aws_instance.bastion.id
  #associate_with_private_ip = "10.0.0.11" #위의 Private ip가 주석처리 되었으므로 얘도 주석처리
  depends_on = [aws_internet_gateway.igw]
}

output "public_ip_bastion" {
  value = aws_instance.bastion.public_ip
}



resource "aws_instance" "web" {
  ami                    = "ami-0263588f2531a56bd"     #리눅스 18.04
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.id_rsa.id
  vpc_security_group_ids = [aws_security_group.security_web.id]
  availability_zone      = "ap-northeast-2a"
  private_ip             = "192.168.2.10" #하도 오류가 많이 나서 일단 주석처리 -> 근데 본인 마음대로 하면 됨
  subnet_id = aws_subnet.web_subnet_1.id
  user_data = file("./ans_web.sh")
  tags = {
    "Name" = "cd-web"
  }
}


resource "aws_instance" "was" {
  ami                    = "ami-0263588f2531a56bd"     #리눅스 18.04
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.id_rsa.id
  vpc_security_group_ids = [aws_security_group.security_was.id]
  availability_zone      = "ap-northeast-2a"
  private_ip             = "192.168.4.10" #하도 오류가 많이 나서 일단 주석처리 -> 근데 본인 마음대로 하면 됨
  subnet_id = aws_subnet.was_subnet_1.id
  user_data = file("./ans_was.sh")
  tags = {
    "Name" = "cd-was"
  }
}



##########################################################################################################3
































#resource "aws_eip" "eip_web_1" {
#  vpc      = true
#  instance = aws_instance.web_1.id
#   #associate_with_private_ip = "10.0.0.11" #위의 Private ip가 주석처리 되었으므로 얘도 주석처리
#  depends_on = [aws_internet_gateway.internet_gateway]
#}
#
#output "public_ip_web_1" {
#  value = aws_instance.web_1.public_ip
#}



/*
resource "aws_instance" "web_2" {
  ami                    = "ami-0263588f2531a56bd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.id_rsa.id
  vpc_security_group_ids = [aws_security_group.security_web.id]
  availability_zone      = "ap-northeast-2c"
  #  private_ip             = "10.0.0.11" #하도 오류가 많이 나서 일단 주석처리 -> 근데 본인 마음대로 하면 됨
  subnet_id = aws_subnet.web_subnet_2.id
  #user_data = file("./httpd.sh")
  tags = {
    "Name" = "cd-web-2"
  }
}
*/

#resource "aws_eip" "eip_web_2" {
#  vpc      = true
#  instance = aws_instance.web_2.id
#   #associate_with_private_ip = "10.0.0.11" #위의 Private ip가 주석처리 되었으므로 얘도 주석처리
#  depends_on = [aws_internet_gateway.internet_gateway]
#}
#
#output "public_ip_web_2" {
#  value = aws_instance.web_2.public_ip
#}


#resource "aws_eip" "eip_was_1" {
#  vpc      = true
#  instance = aws_instance.was_1.id
#   #associate_with_private_ip = "10.0.0.11" #위의 Private ip가 주석처리 되었으므로 얘도 주석처리
#  depends_on = [aws_internet_gateway.internet_gateway]
#}

#output "public_ip_was_1" {
#  value = aws_instance.web_2.public_ip
#}


/*
resource "aws_instance" "was_2" {
  ami                    = "ami-0f8b8babb98cc66d0"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.id_rsa.id
  vpc_security_group_ids = [aws_security_group.security_was.id]
  availability_zone      = "ap-northeast-2c"
  #  private_ip             = "10.0.0.11" #하도 오류가 많이 나서 일단 주석처리 -> 근데 본인 마음대로 하면 됨
  subnet_id = aws_subnet.was_subnet_2.id
  user_data = file("./catpet.sh")
  tags = {
    "Name" = "cd-was-2"
  }
}
*/
#resource "aws_eip" "eip_was_2" {
#  vpc      = true
#  instance = aws_instance.was_2.id
#   #associate_with_private_ip = "10.0.0.11" #위의 Private ip가 주석처리 되었으므로 얘도 주석처리
#  depends_on = [aws_internet_gateway.internet_gateway]
#}

#output "public_ip_was_1" {
#  value = aws_instance.web_2.public_ip
#}