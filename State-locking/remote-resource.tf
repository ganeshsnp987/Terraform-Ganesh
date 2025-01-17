resource "aws_instance" "remote_ec2" {
    count = 2
  ami           = "ami-053b12d3152c0cc71"
  instance_type = "t2.micro"

  tags = {
    Name = "remote-instance"
  }
}