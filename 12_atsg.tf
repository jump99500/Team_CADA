resource "aws_placement_group" "pg" {
  name     = "cd-pg"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "atsg_web" {
  name                      = "cd-atsg-web"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  launch_configuration      = aws_launch_configuration.lacf_web.name
  #placement_group = aws_placement_group.ssw_pg.id
  vpc_zone_identifier = [aws_subnet.web_subnet_1.id, aws_subnet.web_subnet_2.id]
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}



resource "aws_autoscaling_group" "atsg_was" {
  name                      = "cd-atsg-was"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  launch_configuration      = aws_launch_configuration.lacf_was.name
  #placement_group = aws_placement_group.ssw_pg.id
  vpc_zone_identifier = [aws_subnet.was_subnet_1.id, aws_subnet.was_subnet_2.id]
  tag {
    key                 = "Name"
    value               = "was"
    propagate_at_launch = true
  }
}
