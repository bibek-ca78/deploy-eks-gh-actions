# main.tf

provider "aws" {
  region = "us-east-1"
}

terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
 
 backend "s3" {
   region = "us-east-1"
   key    = "terraform.tfstate"
 }
}

resource "aws_instance" "test_instance" {
 ami           = "ami-830c94e3"
 instance_type = "t2.nano"
 tags = {
   Name = "test_instance"
 }
}