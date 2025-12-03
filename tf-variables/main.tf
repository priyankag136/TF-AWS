terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.54.1"
    }
  }
}

provider "aws" {
    region = "eu-west-3"
}

data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["al2023-ami-*-x86_64"]
    }
    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "my-webserver" {
    ami = data.aws_ami.ami.id
    instance_type = var.aws_instance_type
    root_block_device {
      delete_on_termination = true
      #volume_size =30
      #volume_type = "gp2"
      #volume_size = var.root_volume_size
      #volume_type = var.root_volume_type
      volume_size = var.ec2_config.v_size
      volume_type = var.ec2_config.v_type
    }
    /*
    tags = {
      Name = "my-webserver"
    }
    */

    tags = merge(var.additional_tags, { Name = "My-instance" })
}

