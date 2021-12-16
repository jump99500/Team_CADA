resource "aws_lb" "nlb" {
  name               = "cd-nlb"
  internal           = true #내부
  load_balancer_type = "network"
  #  security_groups    = [aws_security_group.security_nlb.id]  nlb는 보안그룹 따로 안 받음?
  subnets = [aws_subnet.web_subnet_1.id, aws_subnet.web_subnet_2.id]
/*  access_logs {
    bucket  = aws_s3_bucket.log_bucket.bucket
    enabled = true
  }
  tags = {
    "Name" = "ssw-nlb-was"
  }
 */ 
}

output "dns_name1" {
  value = aws_lb.nlb.dns_name
}

resource "aws_lb_target_group" "nlb_target" {
  name     = "cd-nlb-tg"
  port     = "8080"
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id
}


resource "aws_lb_listener" "nlb_front_tomcat" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target.arn
  }
}


resource "aws_lb_target_group_attachment" "nlb_target_att" {
  target_group_arn = aws_lb_target_group.nlb_target.arn
  target_id        = aws_instance.was.id
  port             = 8080

}
/*
resource "aws_lb_target_group_attachment" "nlb_target_ass_2" {
  target_group_arn = aws_lb_target_group.nlb_target.arn
  target_id        = aws_instance.was_2.id
  port             = 8080

}
*/

/*
  #  health_check {
  #  enabled               = true
  #  healthy_threshold     = 3
  #  interval              = 5
    #matcher               = "200"
    #path                  = "/health.html" 
  #  port                  = "8080"
  #  protocol              = "TCP" #fffff
  #  timeout               = 2
  #  unhealthy_threshold   = 2 
#  }

}
*/
