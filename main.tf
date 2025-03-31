# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main_vpc"
  }
}

# Public Subnet 1 for Webserver
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.cidr_public_subnet1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
}

# Public Subnet 2 for Webserver
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.cidr_public_subnet2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.cidr_private_subnet1
  availability_zone = var.az1

  tags = {
    Name = "private_subnet_1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.cidr_private_subnet2
  availability_zone = var.az2

  tags = {
    Name = "private_subnet_2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route_table_public"
  }
}

# Route Table Association with Public Subnet 1
resource "aws_route_table_association" "rta_public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_public.id
}

# Route Table Association with Public Subnet 2
resource "aws_route_table_association" "rta_public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_table_public.id
}

# Route Table for Private Subnets
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route_table_private"
  }
}

# Route Table Association with Private Subnet 1
resource "aws_route_table_association" "rta_private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.route_table_private.id
}

# Route Table Association with Private Subnet 2
resource "aws_route_table_association" "rta_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.route_table_private.id
}