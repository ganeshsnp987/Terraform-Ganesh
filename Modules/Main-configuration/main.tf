provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "/home/ganesh/Terraform/Modules/EC2-module"

}

module "aws_s3_bucket" {
  source = "/home/ganesh/Terraform/Modules/S3-Module"

}