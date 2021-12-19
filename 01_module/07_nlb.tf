resource "aws_lb" "nlb" {
  name               = format("%s-nlb", var.name)
  internal           = true #내부
  load_balancer_type = "network"
  #  security_groups    = [aws_security_group.security_nlb.id]  nlb는 보안그룹 따로 안 받음?
  subnets = aws_subnet.web_subnet.*.id
  access_logs {
    bucket  = aws_s3_bucket.cada_s3.bucket
    enabled = true
  }
  tags = {
    "Name" = "${format("%s-nlb", var.name)}"
  }
}

output "dns_name1" {
  value = aws_lb.nlb.dns_name
}

resource "aws_lb_target_group" "nlb_target" {
  name        = format("%s-nlb-tg", var.name)
  port        = var.nlb.port
  protocol    = var.nlb.protocol
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}


resource "aws_lb_listener" "nlb_front_tomcat" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.nlb.port
  protocol          = var.nlb.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target.arn
  }
}


resource "aws_lb_target_group_attachment" "nlb_target_att" {
  count = var.was.count
  target_group_arn = aws_lb_target_group.nlb_target.arn
  target_id        = aws_instance.was[count.index].id
  port             = var.nlb.port

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
