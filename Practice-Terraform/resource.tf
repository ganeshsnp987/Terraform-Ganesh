###########Variable, Count, Data-types, Conditional Expression##################
# resource "aws_instance" "web1" {
#   count         = var.is_test_env == true ? 1 : 0
#   ami           = "ami-053b12d3152c0cc71"
#   instance_type = var.instance_type_map[tostring(count.index)]

#   tags = {
#     Name = "${var.instance_name[count.index]}-${count.index + 1}"
#   }
# }

# resource "aws_instance" "web2" {
#   count         = var.is_test_env == false ? 2 : 0
#   ami           = "ami-053b12d3152c0cc71"
#   instance_type = var.instance_type_map[tostring(count.index + 1)]

#   tags = {
#     Name = "${var.instance_name[count.index + 1]}-${count.index + 2}"
#   }
# }
############Locals, toset, for_each, Dependens on, Lifecycle, Data-source, Output################################################################
resource "aws_instance" "web3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  #   tags = {
  #     Name = "Devops"
  #     Purpose = "Deployment-app"
  #   }
  tags       = local.common_tag
  depends_on = [aws_instance.web4]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "web4" {
  for_each      = local.instance_name
  ami           = each.value
  instance_type = "t2.micro"

  #   tags = {
  #     Name = "Devops"
  #     Purpose = "Deployment-app"
  #   }
  tags = {
    Name = each.key
  }
}

##############Variables, Data-types, Dynamic-block########################################################
# resource "aws_security_group" "allow_tls" {
#   name = "allow_tls"

#   dynamic "ingress" {
#     for_each = var.port_number
#     iterator = ports
#     content {
#       from_port   = ports.value
#       to_port     = ports.value
#       protocol    = "tcp"
#       cidr_blocks = [var.cidr]

#     }
#   }

#   dynamic "egress" {
#     for_each = var.port_number
#     iterator = ports
#     content {
#       from_port   = ports.value
#       to_port     = ports.value
#       protocol    = "tcp"
#       cidr_blocks = [var.cidr]

#     }
#   }


#   ingress {

#     from_port   = var.port_number[0]
#     to_port     = var.port_number[0]
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr]
#   }

#   ingress {

#     from_port   = var.port_number[1]
#     to_port     = var.port_number[1]
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr]
#   }
#   ingress {

#     from_port   = var.port_number[2]
#     to_port     = var.port_number[2]
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr]
#   }
#   ingress {

#     from_port   = var.port_number[3]
#     to_port     = var.port_number[3]
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr]
#   }

#   egress {
#     from_port   = var.port_number[0]
#     to_port     = var.port_number[0]
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr]
#   }

#   tags = {
#     Name = var.sg_name
#   }
# }


##############Provider: Local_file, Random-string########################

# resource "local_file" "Devops" {
#   filename = "/home/ganesh/Terraform/terraform-automated.txt"
#   content  = "I want to become devops engineer, who knows terraform"


# }

# resource "random_string" "rand-str" {
#   length           = 16
#   special          = true
#   override_special = "~!@#$%^&*()_+"


# }

###################Docker with terraform###############
# resource "docker_image" "nginx" {
#   name         = "nginx:latest"
#   keep_locally = false
# }

# resource "docker_container" "nginx" {
#   image = docker_image.nginx.name
#   name  = "nginx-container"
#   ports {
#     internal = 80
#     external = 80
#   }
# }