terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "${var.AWS_REGION}"
  # access_key = "${var.akey}"
  # secret_key = "${var.skey}"
}
