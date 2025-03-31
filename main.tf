# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
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