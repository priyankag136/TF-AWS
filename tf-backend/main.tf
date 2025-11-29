terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.0"
    }
  }

  backend "s3" {
    bucket = "bucket-priya-15100712840248181014"
    key = "backend.tfstate"
    region = "ap-south-1"
  }
}

provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "websever" {
    ami = "ami-0d176f79571d18a8f"
    instance_type = "t3.micro"
    subnet_id = "subnet-03d9b42f65b62716a"
    tags = {
      Name = "mumbai-instance"
    }
}