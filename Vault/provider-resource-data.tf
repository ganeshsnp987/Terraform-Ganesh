provider "vault" {
  address          = "http://127.0.0.1:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "70f8f45e-e894-75a5-955a-21469f1335b5"
      secret_id = "05912e6a-5f03-bff8-ff32-28399d4074ed"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "secret"
}

resource "aws_instance" "server" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"

    tags = {
         secret = data.vault_kv_secret_v2.example.data["username"]
    }
  
}