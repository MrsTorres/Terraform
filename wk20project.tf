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
  cidr_block = "10.0.0.0/16"
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
