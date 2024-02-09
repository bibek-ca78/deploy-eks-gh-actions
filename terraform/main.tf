# # main.tf

# provider "aws" {
#   region = "us-east-1"
# }

# terraform {
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#    }
#  }
 
#  backend "s3" {
#    region = "us-east-1"
#    key    = "terraform.tfstate"
#  }
# }


# # Create a VPC
# resource "aws_vpc" "my_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create public and private subnets
# resource "aws_subnet" "public_subnet_1" {
#   vpc_id                  = aws_vpc.my_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone =  "us-east-1a" # Specify availability zone
# }

# resource "aws_subnet" "public_subnet_2" {
#   vpc_id                  = aws_vpc.my_vpc.id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = true
#   availability_zone =  "us-east-1b" # Specify availability zone
# }


# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.my_vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone       = "us-east-1c"  # Specify availability zone
# }

# # Create a security group for the EKS cluster
# resource "aws_security_group" "eks_security_group" {
#   vpc_id = aws_vpc.my_vpc.id

#   # Allow inbound traffic on port 443 from anywhere (for Kubernetes API)
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow inbound traffic on port 80 from anywhere (for HTTP)
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

