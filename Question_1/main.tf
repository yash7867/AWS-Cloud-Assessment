# Terraform Block
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "Assessment"
      CreatedBy   = "yashchaurasiya"
      Project     = "Task1_VPC_Networking"
    }
  }
}

# VPC Block
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Yash_Chaurasiya_VPC"
  }
}

# Internet Gateway Block
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Yash_Chaurasiya_IGW"
  }
}

# Public Subnet 1 (AZ: ap-south-1a)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Yash_Chaurasiya_Public_Subnet_1"
  }
}

# Public Subnet 2 (AZ: ap-south-1b)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Yash_Chaurasiya_Public_Subnet_2"
  }
}

# Private Subnet 1 (AZ: ap-south-1a)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Yash_Chaurasiya_Private_Subnet_1"
  }
}

# Private Subnet 2 (AZ: ap-south-1b)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Yash_Chaurasiya_Private_Subnet_2"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "Yash_Chaurasiya_EIP_NAT"
  }

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway (in public subnet 1)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "Yash_Chaurasiya_NAT_Gateway"
  }

  depends_on = [aws_internet_gateway.main]
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Yash_Chaurasiya_Public_RT"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "Yash_Chaurasiya_Private_RT"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# Outputs
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_1.id
  description = "ID of Public Subnet 1"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public_2.id
  description = "ID of Public Subnet 2"
}

output "private_subnet_1_id" {
  value       = aws_subnet.private_1.id
  description = "ID of Private Subnet 1"
}

output "private_subnet_2_id" {
  value       = aws_subnet.private_2.id
  description = "ID of Private Subnet 2"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "ID of Internet Gateway"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.main.id
  description = "ID of NAT Gateway"
}

output "nat_gateway_public_ip" {
  value       = aws_eip.nat.public_ip
  description = "Public IP of NAT Gateway"
}
