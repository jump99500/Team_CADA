resource "aws_ami_from_instance" "ami_web" {
  name               = "cd-ami-web"
  source_instance_id = aws_instance.web.id
  depends_on = [
    aws_instance.web
  ]
}

resource "aws_ami_from_instance" "ami_was" {
  name               = "cd-ami-was"
  source_instance_id = aws_instance.was.id
  depends_on = [
    aws_instance.was
  ]
}

