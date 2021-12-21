resource "aws_launch_configuration" "cd_weblacf" {
  name                 = "cd-weblacf"
  image_id             = aws_ami_from_instance.ami_web.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.sg_web.id]
  key_name             = "id_rsa"
  iam_instance_profile = aws_iam_instance_profile.profile_web.name
  user_data = file("./s3_mount.sh")
}

#배치 그룹
resource "aws_placement_group" "cd_webpg" {
  name     = "cd-webpg"
  strategy = "cluster"
}
#오토스케일링 그룹
resource "aws_autoscaling_group" "cd_webatsg" {
  name                      = "cd-webatsg"
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  #placement_group = aws_placement_group.cd_webpg.id
  launch_configuration = aws_launch_configuration.cd_weblacf.name
  vpc_zone_identifier  = [aws_subnet.cd_priweb1.id, aws_subnet.cd_priweb2.id]
  
  /*provisioner "local-exec" {
    command = "getips.sh"
  }*/

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "cd_webasatt" {
  autoscaling_group_name = aws_autoscaling_group.cd_webatsg.id
  alb_target_group_arn   = aws_lb_target_group.cd_albtg.arn
}

resource "aws_launch_configuration" "cd_waslacf" {
  name                 = "cd-waslacf"
  image_id             = aws_ami_from_instance.ami_was.id
  instance_type        = "t3.medium"
  iam_instance_profile = "ec2-cd" #IAM 역할 만든거
  security_groups      = [aws_security_group.sg_was.id]
  key_name             = "id_rsa"
  user_data = file("./efs_mount.sh")
}

#배치 그룹
resource "aws_placement_group" "cd_waspg" {
  name     = "cd-waspg"
  strategy = "cluster"
}
#오토스케일링 그룹
resource "aws_autoscaling_group" "cd_wasatsg" {
  name                      = "cd-wasatsg"
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  #placement_group = aws_placement_group.cd_waspg.id
  launch_configuration = aws_launch_configuration.cd_waslacf.name
  vpc_zone_identifier  = [aws_subnet.cd_priwas1.id, aws_subnet.cd_priwas2.id]

  tag {
    key                 = "Name"
    value               = "was"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "cd_wasasatt" {
  autoscaling_group_name = aws_autoscaling_group.cd_wasatsg.id
  alb_target_group_arn   = aws_lb_target_group.cd_nlbtg.arn
}



