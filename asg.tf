resource "aws_autoscaling_group" "submission-autoscaling" {
  name                = "submission-autoscaling"
  vpc_zone_identifier = [aws_subnet.my-private-1.id, aws_subnet.my-private-2.id]
  launch_template {
    id      = aws_launch_template.submission_lt.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  
  target_group_arns         = [aws_lb_target_group.lb_tg.arn] 
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "submission instances"
    propagate_at_launch = true
  }
}
