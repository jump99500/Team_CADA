resource "aws_autoscaling_attachment" "cd_asatt_web" {
  autoscaling_group_name = aws_autoscaling_group.atsg_web.id
  alb_target_group_arn   = aws_lb_target_group.alb_target.arn
}

resource "aws_autoscaling_attachment" "cd_asatt_was" {
  autoscaling_group_name = aws_autoscaling_group.atsg_was.id
  alb_target_group_arn   = aws_lb_target_group.nlb_target.arn 
}