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

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "My-vpc"
    }  
}

# private - subnet
resource "aws_subnet" "private-subnet" {
   vpc_id = aws_vpc.my-vpc.id
   cidr_block = "10.0.1.0/24"
   tags = {
        Name = "Private-Subnet"
    } 
}

# public - subnet
resource "aws_subnet" "public-subnet" {
   vpc_id = aws_vpc.my-vpc.id
   cidr_block = "10.0.2.0/24"
   tags = {
        Name = "Public-Subnet"
    } 
}

# Internet Gateway
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "My-internet-gateway"
    }  
}

# Routing Table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
}

resource "aws_route_table_association" "public-subnet" {
    route_table_id = aws_route_table.my-rt.id
    subnet_id = aws_subnet.public-subnet.id
  
}

resource "aws_instance" "my-instance" {
    ami="ami-0fa3fe0fa7920f68e"
    instance_type = "t3.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.public-subnet.id
    tags = {
      Name = "My-WebServer"
    }
}
