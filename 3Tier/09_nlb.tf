resource "aws_lb" "cd_nlb" {
  name               = "cd-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.cd_priweb1.id, aws_subnet.cd_priweb2.id]
}

resource "aws_lb_target_group" "cd_nlbtg" {
  name        = "cd-nlbtg"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.cd_vpc.id
}

resource "aws_lb_listener" "cd_nlblis" {
  load_balancer_arn = aws_lb.cd_nlb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cd_nlbtg.arn
  }
}

output "nlb_dns_name" {
  value = aws_lb.cd_nlb.dns_name
}