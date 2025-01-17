terraform {
  backend "s3" {
    bucket         = "ganesh-terraform-local-stuff-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ganesh-terraform-local-stuff-table"
  }
}