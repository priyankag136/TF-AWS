output "instance_public_ip" {
    description = "The public ip address of the ec2 instance"
    value = aws_instance.nginx-instance.public_ip
}

output "instance_url" {
    description = "The URL to  access Nginx server"
    value = "http://${aws_instance.nginx-instance.public_ip}"
  
}