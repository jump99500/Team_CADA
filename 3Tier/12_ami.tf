resource "aws_ami_from_instance" "ami_web" {
  name = "ami-web"
  source_instance_id = aws_instance.web.id
  depends_on = [
    aws_instance.web,
    time_sleep.wait_web
  ]
}


resource "aws_ami_from_instance" "ami_was" {
  name = "ami-was"
  source_instance_id = aws_instance.was.id
  depends_on = [
    aws_instance.was,
    time_sleep.wait_was
  ]
}
