# Output for VPC ID
output "vpc_id" {
  description = "VPC ID Address"
  value       = aws_vpc.dev-vpc.id
}

# Output for Subnets (all subnets created by for_each)
output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for key, subnet in aws_subnet.dev-subnet : key => subnet.id }
}

# Output for Web Server Public and Private IP
output "instance_public_ip" {
  description = "Public IP address of Web Server"
  value       = aws_instance.web-server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of Web Server"
  value       = aws_instance.web-server.private_ip
}

# Output for Ansible Server Public and Private IP
output "ansible_public_ip" {
  description = "Public IP address of Ansible Server"
  value       = aws_instance.ansible-server.public_ip
}

output "ansible_private_ip" {
  description = "Private IP address of Ansible Server"
  value       = aws_instance.ansible-server.private_ip
}

# Output for Route Table Associations (all associations created by for_each)
output "routing_table_associations" {
  description = "Route Table Associations"
  value       = { for key, assoc in aws_route_table_association.a : key => assoc.id }
}

# Output for Private IP of Ansible Nodes
output "node1_private_ip" {
  description = "Private IP address of Ansible Node1"
  value       = aws_instance.docker-server1.private_ip
}

output "node2_private_ip" {
  description = "Private IP address of Ansible Node2"
  value       = aws_instance.docker-server2.private_ip
}
