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

locals {
  project = "Project-01"
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.project}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count = 2
  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}

output "aws_subnet_id" {
  value = aws_subnet.main[*].id
}
##### Task 1 ######

##### Task 2 ######
/*
resource "aws_instance" "main" {
  ami = "ami-00769f46ca3bb4381"
  instance_type = "t3.micro"
  count = 4
  #subnet_id = element(aws_subnet.main[*].id,count.index % 2)
  # 0 % 2 = 0
  # 1 % 2 = 1
  # 2 % 2 = 0
  # 3 % 2 = 1
  subnet_id = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))
  
  tags = {
    Name = "${local.project}-instance-${count.index}"
  }
} */

##### Task 3 ######
# Creating EC2-instance using count
/*
resource "aws_instance" "main" {
  
  count = length(var.ec2_config)
  ami = var.ec2_config[count.index].ami
  instance_type = var.ec2_config[count.index].instance_type
  
  subnet_id = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))
  
  tags = {
    Name = "${local.project}-instance-${count.index}"
  }
} */

##### Task 4 ######
# Creating EC2-instance using for_each

resource "aws_instance" "main" {
  
  for_each = var.ec2_map
  # we will get each.key and each.value

  ami = each.value.ami
  instance_type = each.value.instance_type

  subnet_id = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.main))
  
  tags = {
    Name = "${local.project}-instance-${each.key}"
  }
}