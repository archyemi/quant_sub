resource "aws_security_group" "lb-sg" {
  vpc_id      = aws_vpc.submission.id
  name        = "allow-http"
  description = "security group that allows http and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "lb-sg"
  }
}

resource "aws_security_group" "allow-lb" {
  vpc_id      = aws_vpc.submission.id
  name        = "allow-loadbalancer traffic"
  description = "allow lb traffic to instances"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb-sg.id}"] # allowing access from our example instance
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "allow-lb-sg"
  }
}
