resource "aws_instance" "nginx-instance" {
    ami="ami-0fa3fe0fa7920f68e"
    instance_type = "t3.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.public-subnet.id
    availability_zone = "us-east-1a"

    vpc_security_group_ids = [aws_security_group.nginx-sg.id]

    user_data = <<-EOF
            #!bin/bash
            sudo yum install nginx -y
            sudo systemctl start nginx
            EOF

    tags = {
      Name = "NGINX-WebServer"
    }
}