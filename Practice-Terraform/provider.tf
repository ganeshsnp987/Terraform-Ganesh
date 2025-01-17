#######################AWS-Provider#######################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#######################Docker-Provider#######################

# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "~>2.21.0"
#     }
#   }
# }

# provider "docker" {

# }
#######################Vault-Provider#######################

# provider "vault" {
#   region           = "ap-south-1"
#   address          = "http://localhost:8200"
#   skip_child_token = true

#   auth_login {
#     path = "auth/approle/login"

#     parameters = {
#       role_id   = "f69080bf-a20f-4af2-2765-039be3f72883"
#       secret_id = "bca80959-a0ae-2b85-42e9-05f0ce4e145e"
#     }
#   }
# }