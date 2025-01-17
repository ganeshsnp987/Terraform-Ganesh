#!/bin/bash
# Update the package index
apt update -y

# Install Apache2
apt install apache2 -y

# Start the Apache2 service
systemctl start apache2

# Enable Apache2 to start on boot
systemctl enable apache2

# Create a sample HTML page
echo "<h1>Welcome to Terraform Empire...!!</h1>" > /var/www/html/index.html