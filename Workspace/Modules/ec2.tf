provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami           = var.ami
  instance_type = var.instance_type

}

variable "ami" {


}
variable "instance_type" {

}