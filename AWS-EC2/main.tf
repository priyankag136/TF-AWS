terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.0"
    }
  }
}

# ============================================================
# Providers
# ============================================================

# us-east-1 (no default VPC available)
provider "aws" {
  alias="east"
  region = "us-east-1"
}

# us-west-2 (default VPC exists)
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# ============================================================
# VPC + Subnet + IGW + Route Table for us-east-1
# ============================================================

resource "aws_vpc" "east_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "east-vpc"
  }
}

resource "aws_subnet" "east_subnet" {
  vpc_id                  = aws_vpc.east_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "east-subnet"
  }
}

resource "aws_internet_gateway" "east_igw" {
  vpc_id = aws_vpc.east_vpc.id
}

resource "aws_route_table" "east_rt" {
  vpc_id = aws_vpc.east_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.east_igw.id
  }
}

resource "aws_route_table_association" "east_assoc" {
  subnet_id      = aws_subnet.east_subnet.id
  route_table_id = aws_route_table.east_rt.id
}

resource "aws_security_group" "east_sg" {
  name   = "east-sg"
  vpc_id = aws_vpc.east_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================
# EC2 in us-east-1 (uses created VPC)
# ============================================================

data "aws_ami" "east_ami" {
  provider    = aws.east
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon Linux 2 official owner
}

resource "aws_instance" "east_instance" {
  ami                         = data.aws_ami.east_ami.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.east_subnet.id
  vpc_security_group_ids      = [aws_security_group.east_sg.id]

  tags = {
    Name = "Instance-East"
  }
}

# ============================================================
# EC2 in us-west-2 (uses default VPC)
# ============================================================

data "aws_ami" "west_ami" {
  provider    = aws.west
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon Linux 2 official owner
}

resource "aws_instance" "west_instance" {
  provider      = aws.west
  ami = data.aws_ami.west_ami.id
  
  instance_type = "t3.micro"

  tags = {
    Name = "Instance-West"
  }
}

# ============================================================
# Outputs
# ============================================================

output "east_instance_public_ip" {
  value = aws_instance.east_instance.public_ip
}

output "west_instance_public_ip" {
  value = aws_instance.west_instance.public_ip
}
