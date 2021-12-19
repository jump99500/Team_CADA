resource "aws_ami_from_instance" "ami_web" {
  name               = "${format("%s-ami", var.name)}"
  source_instance_id = aws_instance.web[0].id
  depends_on = [
    aws_instance.web
  ]
}

resource "aws_ami_from_instance" "ami_was" {
  name               = "${format("%s-was", var.name)}"
  source_instance_id = aws_instance.was[0].id
  depends_on = [
    aws_instance.was
  ]
}

