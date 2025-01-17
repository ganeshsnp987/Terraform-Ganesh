variable "cidr" {
  # default = "44.55.66.77/32"

}

variable "instance_type_map" {
  type = map(string)
  #   default = {
  #     "test"   = "t2.nano"
  #     "prod"   = "t2.small"
  #     "deploy" = "t2.micro"
  #   }
}

variable "instance_name" {
  #   description = "Enter name of instance:"
  #   default = "ganesh-server"
}

variable "port1" {
  type = number

}
variable "port2" {
  type = number
}
variable "port3" {
  type = number
}
variable "port4" {
  type = number
}

variable "sg_name" {
  type = string

}

variable "port_number" {
  # description = "Enter four ports number for inbound rule:"
  type = list(number)
  # default = [ "8000","9000","8080","9090" ]
}

variable "is_test_env" {
  type = bool
  # default = true

}

variable "aws_ec2_object" {
  type = object({
    name     = string
    instance = number
    keys     = list(string)
    ami      = string
  })
  default = {
    name     = "test_ec2_instance"
    instance = 4
    keys     = ["key1.pem", "key2.pem"]
    ami      = "ubuntu-abcd"
  }
  #   sensitive = true
}

locals {
  common_tag = {
    Name    = "Devops"
    Purpose = "Deployment-app"
  }
}

#Set of Instance Names:
# locals {
#   instance_name = toset(["test", "prod", "dev", "monitor"]) #list converted to set using toset
# }

#Map of Instance Names to AMI IDs (Using tomap):
# locals {
#   instance_name = tomap({
#     test    = "ami-0f5ee92e2d63afc18"
#     prod    = "ami-0f5ee92e2d63afc18"
#     dev     = "ami-06f621d90fa29f6d0"
#     monitor = "ami-06f621d90fa29f6d0"
#   })
# }

#Map of Instance Names to AMI IDs (Direct Map Syntax)
locals {
  instance_name = {
    "test" : "ami-0f5ee92e2d63afc18"
    "prod" : "ami-0f5ee92e2d63afc18"
    "dev" : "ami-06f621d90fa29f6d0"
    "monitor" : "ami-06f621d90fa29f6d0"
  }
}