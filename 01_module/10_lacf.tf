resource "aws_launch_configuration" "lacf_web" {
  name                 = "${format("%s-lacf-web", var.name)}"
  image_id             = aws_ami_from_instance.ami_web.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.profile_web.name #IAM 역할 만든거
  security_groups      = [aws_security_group.security_web.id]
  key_name             = var.key.name
  user_data            = file("${path.module}/s3_mount.sh")
}

resource "aws_launch_configuration" "lacf_was" {
  name                 = "${format("%s-lacf-was", var.name)}"
  image_id             = aws_ami_from_instance.ami_was.id
  instance_type        = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.profile_web.name #IAM 역할 만든거
  security_groups      = [aws_security_group.security_was.id]
  key_name             = var.key.name
  user_data            = file("${path.module}/efs_mount.sh")
}