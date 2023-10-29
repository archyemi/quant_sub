resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my-elb.arn
  port              = "80"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "submission-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.submission.id
  health_check {
      healthy_threshold = 2
      path = "/index.html"
  }
}

resource "aws_lb" "my-elb" {
  name               = "my-elb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.my-public-1.id, aws_subnet.my-public-2.id]
  security_groups    = [aws_security_group.lb-sg.id]
  
  tags = {
    Name = "my-elb"
  }
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.submission-autoscaling.id
  lb_target_group_arn = aws_lb_target_group.lb_tg.arn
}
