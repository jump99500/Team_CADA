resource "aws_lb" "cd_alb" {
  name               = "cd-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.cd_pub1.id, aws_subnet.cd_pub2.id]
  access_logs {
        bucket = aws_s3_bucket.cd_log_bucket.bucket
        enabled = true
    }
  tags = {
    "Name" = "cd-alb"
  }
}

resource "aws_lb_target_group" "cd_albtg" {
  name        = "cd-albtg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cd_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "cd_alblis" {
  load_balancer_arn = aws_lb.cd_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cd_albtg.arn
  }
}

data "aws_elb_service_account" "cd_elb_account" {}

output "alb_dns_name" {
  value = aws_lb.cd_alb.dns_name
}
