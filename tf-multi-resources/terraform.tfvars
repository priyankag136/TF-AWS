ec2_config = [ {
  ami = "ami-0ef9bcd5dfb57b968"    # Ubuntu
  instance_type = "t3.micro"
},
{
    ami = "ami-00769f46ca3bb4381"  # Amazon Linux
    instance_type = "t3.micro"
} ]

ec2_map = {
  "Ubuntu" = {
    ami = "ami-0ef9bcd5dfb57b968"
    instance_type = "t3.micro"
  },
  "Amazon-Linux"={
    ami = "ami-00769f46ca3bb4381"
    instance_type = "t3.micro"
  }
}