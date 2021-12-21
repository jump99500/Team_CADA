resource "time_sleep" "wait_bastion" {
  depends_on = [aws_instance.web]

  create_duration = "1m"
}

resource "time_sleep" "wait_web" {
  depends_on = [aws_instance.web]

  create_duration = "3m"
}

resource "time_sleep" "wait_was" {
  depends_on = [aws_instance.cd_bastion]

  create_duration = "13m"
}