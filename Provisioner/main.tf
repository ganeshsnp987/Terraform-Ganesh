# AWS provider configuration
provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region.
}


# Key Pair: We need to create keypair where terraform is running using "ssh-keygen -t rsa"
resource "aws_key_pair" "example" {
  key_name   = "terraform-demo"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"  # Subnet CIDR block within the VPC CIDR
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "InternetGateway"
  }
}

# Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RouteTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Security Group
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

# EC2 Instance
resource "aws_instance" "server" {
  ami                    = "ami-053b12d3152c0cc71"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  tags = {
    Name = "Terraform-Provisioned-Server"
  }

  # SSH Connection Configuration
  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  # Remote-exec provisioner to execute commands on the EC2 instance
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists
      "sudo apt-get install -y python3-pip",  # Install Python3 and pip
      "cd /home/ubuntu",
      "sudo apt install -y python3-pip python3-flask",   #sudo pip3 install flask
      "sudo python3 app.py &",
    ]
  }
  # Executes commands on the local machine where Terraform is running.
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}

