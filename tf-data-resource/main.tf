terraform {
    required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "5.54.1"

    }
  }
}

provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "name" {
    most_recent = true
    owners = [ "amazon" ]  
}

output "aws_ami" {
    value = data.aws_ami.name
}

resource "aws_instance" "eest_instance" {
  
  ami = data.aws_ami.name.id
  instance_type = "t3.micro"

  tags = {
    Name = "Instance-East"
  }
}
