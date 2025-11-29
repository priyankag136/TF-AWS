terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.0"
    }
     random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

# ============================================================
# Providers
# ============================================================


provider "aws" {
  alias="south"
  region = "ap-south-1"
}
/*

provider "aws" {
  alias="east"
  region = "us-east-1"
}  */

resource "random_id" "r_id" {
    byte_length = 8  
}

resource "aws_s3_bucket" "bucket-1" {
    provider=aws.south
    bucket = "bucket-priya-${random_id.r_id.dec}"
    tags = {
    Name        = "MyBucket_priya"
    Environment = "Dev"
  }
}
/*
resource "aws_s3_bucket" "bucket-2" {
    provider=aws.east
    bucket = "bucket-tushar-pqrst12345"
    tags = {
    Name        = "MyBucket_tushar"
    Environment = "Dev"
  }
}
*/

resource "aws_s3_object" "bucket-data" {
    provider = aws.south
    bucket = aws_s3_bucket.bucket-1.bucket
    source = "./myfile.txt"
    key = "mydata.txt"
  
}

output "name" {
    value = random_id.r_id.dec
}