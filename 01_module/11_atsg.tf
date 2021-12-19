resource "aws_placement_group" "pg" {
  name     = "${format("%s-lacf-web", var.name)}"
  strategy =  "cluster"
}

resource "aws_autoscaling_group" "atsg_web" {
  name                      = "${format("%s-atsg-web", var.name)}"
  min_size                  = var.atsg_web.min_size
  max_size                  = var.atsg_web.max_size
  health_check_grace_period = var.atsg_web.health_check_grace_period
  health_check_type         = var.atsg_web.health_check_type
  desired_capacity          = var.atsg_web.desired_capacity
  force_delete              = false
  launch_configuration      = aws_launch_configuration.lacf_web.name
  #placement_group = aws_placement_group.ssw_pg.id
  vpc_zone_identifier = "${aws_subnet.web_subnet.*.id}"
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}



resource "aws_autoscaling_group" "atsg_was" {
  name                      = "${format("%s-atsg-was", var.name)}"
  min_size                  = var.atsg_was.min_size
  max_size                  = var.atsg_was.max_size
  health_check_grace_period = var.atsg_was.health_check_grace_period
  health_check_type         = var.atsg_was.health_check_type
  desired_capacity          = var.atsg_was.desired_capacity
  force_delete              = false
  launch_configuration      = aws_launch_configuration.lacf_was.name
  #placement_group = aws_placement_group.ssw_pg.id
  vpc_zone_identifier = "${aws_subnet.was_subnet.*.id}"
  tag {
    key                 = "Name"
    value               = "was"
    propagate_at_launch = true
  }
}
