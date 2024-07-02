#!/bin/bash

# Uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# Update the apt package index and install necessary packages
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Create the keyrings directory if it doesn't exist
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's apt repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again
sudo apt-get update

# Install the latest version of Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify the Docker Engine installation by running the hello-world image
sudo docker run hello-world

# Remove the hello-world image after verification
sudo docker rmi hello-world

# Create the docker group
sudo groupadd docker

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Activate the changes to groups
newgrp docker

echo "Docker installation and setup completed successfully."
