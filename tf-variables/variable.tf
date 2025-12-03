variable "aws_instance_type" {
    description = "What type of instance do you want to create ?"
    type = string
   /*
    validation {
      condition = var.aws_instance_type == "t2.micro" || var.aws_instance_type == "t3.micro"
      error_message = "Instance type only t2 and t3 micro are allowed..."
    }
 */  
}
/*
variable "root_volume_size" {
  type = number
  default = 50
}

variable "root_volume_type" {
    type = string
    default = "gp3"
  
}

variable "ec2_config" {
    type = object({
      v_size = number
      v_type = string
    })

    default = {
      v_size = 55
      v_type = "standard"
    }
  
}
*/

variable "ec2_config" {
    type = map(any)
    default = {
      
    }
}

variable "additional_tags" {
  type = map(string)
  default = {
   # dept="QA"
   # project="MY-PROJECT-QA"
  }

}

