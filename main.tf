resource "aws_vpc" "dhiraj-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "dhiraj-vpc"
  }
}

# SECURITY GROUP

resource "aws_security_group" "dhiraj-sg" {
  name        = "arch-sg"
  description = "Allow ALL inbound traffic"
  vpc_id      = aws_vpc.dhiraj-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dhiraj-sg"
  }
}

resource "aws_subnet" "public_sub_bastion" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.dhiraj-vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "public_sub_bastion_1"
  }
}
resource "aws_subnet" "public_sub_bastion_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.dhiraj-vpc.id
  cidr_block        = "10.0.8.0/24"

  tags = {
    Name = "public_sub_bastion_2"
  }
}

resource "aws_subnet" "private_sub_web_1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.dhiraj-vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_sub_web_1"
  }
}
resource "aws_subnet" "private_sub_web_2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.dhiraj-vpc.id
  cidr_block              = "10.0.7.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_sub_web_2"
  }
}
resource "aws_subnet" "private_sub_app_1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.dhiraj-vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_sub_app_1"
  }
}
resource "aws_subnet" "private_sub_app_2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.dhiraj-vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_sub_app_1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dhiraj-vpc.id

  tags = {
    Name = "internet-gw"
  }
}

resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "e-ip"
  }
}
resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = aws_subnet.public_sub_bastion.id
  allocation_id = aws_eip.elastic_ip.id
  tags = {
    Name = "nat-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dhiraj-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dhiraj-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private_rt"
  }
}
resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.public_sub_bastion.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_rt_web_1" {
  subnet_id      = aws_subnet.private_sub_web_1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_web_2" {
  subnet_id      = aws_subnet.private_sub_web_2.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_app_1" {
  subnet_id      = aws_subnet.private_sub_app_1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_app_2" {
  subnet_id      = aws_subnet.private_sub_app_2.id
  route_table_id = aws_route_table.private_rt.id
}
