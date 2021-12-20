resource "aws_lb" "alb" {
  name               = "${format("%s-alb", var.name)}"
  internal           = false  #외부
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_alb.id]
  subnets            = "${aws_subnet.public.*.id}"
  access_logs {
    bucket = aws_s3_bucket.cada_s3.bucket
    enabled = true
  }
  tags = {
    "Name" = "${format("%s-alb", var.name)}"
  } 
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_lb_target_group" "alb_target" {
    name = "${format("%s-alb-tg", var.name)}"
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

data "aws_elb_service_account" "cd_elb_account" {}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}


resource "aws_lb_target_group_attachment" "alb_target_att" {
  count = var.web.count
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.web[count.index].id   #오류 뜸 -> 변수처리
  port             = "80"

}



#data "aws_elb_service_account" "elb_account" {}

/*
resource "aws_lb_target_group_attachment" "alb_target_ass_2" {
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.web_2.id   #오류 뜸 -> 변수처리
  port             = "80"

}
*/