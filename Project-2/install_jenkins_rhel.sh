#!/bin/bash

# Script to install Docker and run Jenkins as a Docker container on Amazon Linux or Red Hat

# Update the system packages
echo "Updating system packages..."
sudo yum update -y

# Install Docker
echo "Installing Docker..."
sudo yum install -y docker

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to the Docker group (requires re-login to take effect)
echo "Adding $(whoami) to the Docker group..."
sudo usermod -aG docker $(whoami)
sudo chmod 666 /var/run/docker.sock

# Verify Docker installation
docker --version
if [ $? -ne 0 ]; then
    echo "Docker installation failed. Exiting."
    exit 1
fi

# Pull the Jenkins Docker image
echo "Pulling the Jenkins Docker image..."
docker pull jenkins/jenkins:lts

# Create a Docker volume for Jenkins data
echo "Creating a Docker volume for Jenkins data..."
docker volume create jenkins_data

# Run Jenkins container
echo "Running Jenkins container..."
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_data:/var/jenkins_home \
  jenkins/jenkins:lts

# Verify Jenkins container is running
docker ps | grep jenkins
if [ $? -ne 0 ]; then
    echo "Jenkins container failed to start. Check Docker logs."
    exit 1
fi

# Output Jenkins default URL
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Jenkins setup is complete. Access Jenkins at: http://$SERVER_IP:8080"

# End of script
