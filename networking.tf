# Internet VPC
resource "aws_vpc" "submission" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "submission_vpc"
  }
}


# Subnets
resource "aws_subnet" "my-public-1" {
  vpc_id                  = aws_vpc.submission.id
  cidr_block              = var.public_subnet_1
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "my-public-1"
  }
}
resource "aws_subnet" "my-public-2" {
  vpc_id                  = aws_vpc.submission.id
  cidr_block              = var.public_subnet_2
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "my-public-2"
  }
}

resource "aws_subnet" "my-private-1" {
  vpc_id                  = aws_vpc.submission.id
  cidr_block              = var.private_subnet_1
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "my-private-1"
  }
}
resource "aws_subnet" "my-private-2" {
  vpc_id                  = aws_vpc.submission.id
  cidr_block              = var.private_subnet_2
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "my-private-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.submission.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_eip" "eip-1" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my-gw]
}
resource "aws_eip" "eip-2" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my-gw]
}

resource "aws_nat_gateway" "my_nat_1" {
  allocation_id = aws_eip.eip-1.id
  subnet_id     = aws_subnet.my-public-1.id

  tags = {
    Name = "my NAT 1"
  }
}
resource "aws_nat_gateway" "my_nat_2" {
  allocation_id = aws_eip.eip-2.id
  subnet_id     = aws_subnet.my-public-2.id

  tags = {
    Name = "my NAT 2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my-gw]
}

# route tables
resource "aws_route_table" "my-public-rt" {
  vpc_id = aws_vpc.submission.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }

  tags = {
    Name = "my-public-rt"
  }
}

resource "aws_route_table" "my-private-rt" {
  vpc_id = aws_vpc.submission.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_1.id
  }

  tags = {
    Name = "my-private-rt-1"
  }
}

resource "aws_route_table" "my-private-rt2" {
  vpc_id = aws_vpc.submission.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_2.id
  }

  tags = {
    Name = "my-private-rt-2"
  }
}

# route table associations
resource "aws_route_table_association" "my-public-1-a" {
  subnet_id      = aws_subnet.my-public-1.id
  route_table_id = aws_route_table.my-public-rt.id
}
resource "aws_route_table_association" "my-public-2-a" {
  subnet_id      = aws_subnet.my-public-2.id
  route_table_id = aws_route_table.my-public-rt.id
}
resource "aws_route_table_association" "my-private-1-a" {
  subnet_id      = aws_subnet.my-private-1.id
  route_table_id = aws_route_table.my-private-rt.id
}
resource "aws_route_table_association" "my-private-2-a" {
  subnet_id      = aws_subnet.my-private-2.id
  route_table_id = aws_route_table.my-private-rt2.id
}
