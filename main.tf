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

# Security Group for Webservers
resource "aws_security_group" "webserver_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "webserver_sg"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "rds_sg"
  description = "Security group for RDS"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }
}

# Get latest Amazon Linux AMI
data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization_type"
    values = ["hvm"]
  }
}

# Webserver EC2 instance 1
resource "aws_instance" "webserver_1" {
  ami                         = data.aws_ami.amazon_linux_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  user_data                   = file("user-data.sh")
  user_data_replace_on_change = true
  associate_public_ip_address = true

  tags = {
    Name = var.instance1_name
  }
}

# Webserver EC2 instance 2
resource "aws_instance" "webserver_2" {
  ami                         = data.aws_ami.amazon_linux_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  user_data                   = file("user-data.sh")
  user_data_replace_on_change = true
  associate_public_ip_address = true

  tags = {
    Name = var.instance2_name
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "red_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  db_name                = "mysql_db"
  instance_class         = var.db_instance_class
  identifier             = "mysql-db"
  username               = var.db_username
  password               = var.db_password
  port                   = "3306"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  availability_zone      = var.az1
  storage_encrypted      = true
  deletion_protection    = false

  tags = {
    name = "mysql_db"
  }
}