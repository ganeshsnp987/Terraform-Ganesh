# Create VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "dev-subnet" {
  for_each = toset(var.availability_zones)
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, index(var.availability_zones, each.key))
  map_public_ip_on_launch = true
  availability_zone       = each.value
  tags = {
    Name = "dev-subnet-${each.key}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev-igw"
  }
}

# Create Route Table
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}

# Associate Subnets with Route Table
resource "aws_route_table_association" "a" {
  for_each = aws_subnet.dev-subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.dev-route-table.id
}

# Create Security Group
resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
    cidr_blocks = ["0.0.0.0/0"] # Replace with your trusted IP
  }

  ingress {
    description = "Custom-tcp"
    from_port   = 8080
    to_port     = 8080
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
    Name = "allow-web"
  }
}

# Key Pair:
resource "aws_key_pair" "example" {
  key_name   = "linux-server"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

# EC2 Instances
resource "aws_instance" "web-server" {
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet["ap-south-1a"].id
  key_name               = aws_key_pair.example.key_name

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Your very first web server" > /var/www/html/index.html
                EOF

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "docker-server1" {
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet["ap-south-1b"].id
  key_name               = aws_key_pair.example.key_name
  user_data              = file("${path.module}/app2-install.sh")

  tags = {
    Name = "docker-server1"
  }
}

resource "aws_instance" "docker-server2" {
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet["ap-south-1b"].id
  key_name               = aws_key_pair.example.key_name
  user_data              = file("${path.module}/app2-install.sh")

  tags = {
    Name = "docker-server2"
  }
}

resource "aws_instance" "ansible-server" {
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet["ap-south-1a"].id
  key_name               = aws_key_pair.example.key_name
  user_data              = file("${path.module}/app1-install.sh")

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
  inline = [
    "set -ex",
    "sudo bash -c 'echo ${aws_instance.docker-server1.private_ip} node1 >> /etc/hosts'",
    "sudo bash -c 'echo ${aws_instance.docker-server2.private_ip} node2 >> /etc/hosts'"
  ]
}

  tags = {
    Name = "ansible-server"
  }
}

resource "aws_instance" "jenkins-server" {
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet["ap-south-1b"].id
  key_name               = aws_key_pair.example.key_name
  user_data              = file("${path.module}/install_jenkins_rhel.sh")

  tags = {
    Name = "jenkins-server"
  }
}