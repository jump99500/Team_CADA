resource "aws_lb" "alb" {
  name               = "cd-alb"
  internal           = false  #외부
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_alb.id]
  subnets            = [aws_subnet.pub_1.id, aws_subnet.pub_2.id]
/*  access_logs {
    bucket = aws_s3_bucket.log_bucket.bucket
    enabled = true
  }
  tags = {
    "Name" = "cd-alb"
  }
 */ 
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_lb_target_group" "alb_target" {
    name = "cd-alb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
  
    health_check {
    enabled               = true
    healthy_threshold     = 3
    interval              = 5
    matcher               = "200"
    path                  = "/health.html" 
    port                  = "traffic-port"
    protocol              = "HTTP"
    timeout               = 2
    unhealthy_threshold   = 2 
  }

}


resource "aws_lb_listener" "alb_front_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}


resource "aws_lb_target_group_attachment" "alb_target_att" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.web.id   #오류 뜸 -> 변수처리
  port             = "80"

}



data "aws_elb_service_account" "elb_account" {}

/*
resource "aws_lb_target_group_attachment" "alb_target_ass_2" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.web_2.id   #오류 뜸 -> 변수처리
  port             = "80"

}
*/