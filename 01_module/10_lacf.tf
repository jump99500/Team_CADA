resource "aws_launch_configuration" "lacf_web" {
  name                 = "${format("%s-lacf-web", var.name)}"
  image_id             = aws_ami_from_instance.ami_web.id
  instance_type        = "t2.micro"
  iam_instance_profile = "ssw8927_role" #IAM 역할 만든거
  security_groups      = [aws_security_group.security_web.id]
  key_name             = var.key.name
  user_data            = file("./control.sh")
}

resource "aws_launch_configuration" "lacf_was" {
  name                 = "${format("%s-lacf-was", var.name)}"
  image_id             = aws_ami_from_instance.ami_was.id
  instance_type        = "t2.medium"
  iam_instance_profile = "ssw8927_role" #IAM 역할 만든거
  security_groups      = [aws_security_group.security_was.id]
  key_name             = var.key.name
  user_data            = file("./efs_mount.sh")
}