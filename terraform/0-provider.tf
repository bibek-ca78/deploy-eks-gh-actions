# provider "aws" {
#   region = "us-east-1"
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

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
