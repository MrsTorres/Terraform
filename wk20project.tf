#Define the provider within Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "green-vpc"
  }
}

#Create the Public Subnets
resource "aws_subnet" "publicsub_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  man_public_ip_on_launch = true

  tags = {
    Name = "publicsub_1"
  }

}

resource "aws_subnet" "publicsub_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  man_public_ip_on_launch = true

  tags = {
    Name = "publicsub_2"
  }
}

#Create the Private Subnets
resource "aws_subnet" "privatesub_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  man_public_ip_on_launch = false

  tags = {
    Name = "privatesub_1"
  }
}
resource "aws_subnet" "privatesub_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  man_public_ip_on_launch = false

  tags = {
    Name = "privatesub_2"

  }
}
#Create the Route Table to the Internet Gateway
resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "project-rt"
  }
}

#Connect the Public Subnets to the Route Table
resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.project_rt.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.project_rt.id
}

#Create the Security Groups
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow web tier and ssh traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
    security_groups = [aws_security_group.public_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}