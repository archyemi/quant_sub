data "aws_ami" "amazon_ami" {
  most_recent = true
  

  filter {
    name   = "name"
    values = ["Amazon Linux 2 *"]
  }
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}


resource "aws_launch_template" "submission_lt" {
  name = "submission_launch_template"

  image_id                             = data.aws_ami.amazon_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.large"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.allow-lb.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "submission launch template"
    }
  }

  user_data = filebase64("${path.module}/run.sh")
}
