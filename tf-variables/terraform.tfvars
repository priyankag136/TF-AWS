aws_instance_type = "t3.micro"
ec2_config = {
  v_size = 40
  v_type = "gp2"
}

additional_tags = {
   project = "ice-cream corner"
   service = "s3-iam-ec2"
}