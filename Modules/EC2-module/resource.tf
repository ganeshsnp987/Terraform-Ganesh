resource "aws_instance" "my-ec2" {
for_each = local.instances
ami = each.value
instance_type = "t2.micro"
tags = {
    Name = each.key
  }
}