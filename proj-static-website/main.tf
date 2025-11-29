terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "mywebapp-bucket" {
  bucket = "mywebapp-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp_policy" {
  bucket = aws_s3_bucket.mywebapp-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "${aws_s3_bucket.mywebapp-bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "mywebapp_web_config" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  index_document {
    suffix = "index.html"
  }
}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mywebapp-bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.mywebapp-bucket.bucket
  source       = "./styles.css"
  key          = "styles.css"
  content_type = "text/css"
}

locals {
  image_files = {
    "image-01.jpg" = "C:\\Users\\Priyanka Gangawane\\Desktop\\MyWebsite\\images\\image-01.jpg"
    "image-02.jpg" = "C:\\Users\\Priyanka Gangawane\\Desktop\\MyWebsite\\images\\image-02.jpg"
    "image-03.jpg" = "C:\\Users\\Priyanka Gangawane\\Desktop\\MyWebsite\\images\\image-03.jpg"
  }
}

resource "aws_s3_object" "images" {
  for_each = local.image_files

  bucket = aws_s3_bucket.mywebapp-bucket.bucket
  key    = "images/${each.key}"
  source = each.value
  etag   = filemd5(each.value)
}

output "name" {
  value = aws_s3_bucket_website_configuration.mywebapp_web_config.website_endpoint
}
