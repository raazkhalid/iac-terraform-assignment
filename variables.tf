variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance1_name" {
  description = "Name for EC2 instance 1"
  type        = string
  default = "instance1"
}

variable "instance2_name" {
  description = "Name for EC2 instance 2"
  type        = string
  default = "instance2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
  default     = "us-east-1b"
}

variable "cidr_public_subnet1" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_private_subnet1" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.2.0/24"
}

variable "cidr_public_subnet2" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.3.0/24"
}

variable "cidr_private_subnet2" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "RDS instance username"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "RDS instance password"
  type        = string
  sensitive   = true
}