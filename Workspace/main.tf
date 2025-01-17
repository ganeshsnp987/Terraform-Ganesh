provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  type = map(string)
    default = {
      "dev" = "ami-053b12d3152c0cc71"
      "stage" = "ami-053b12d3152c0cc71"
      "prod" = "ami-053b12d3152c0cc71"
    }
}

variable "instance_type" {
    type = map(string)
    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.large"
    }
  
}

module "test_ec2_instance" {
  source = "/home/ganesh/Terraform/Workspace/Modules"
  ami = lookup(var.ami, terraform.workspace, "ami-053b12d3152c0cc71")
 instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")

}