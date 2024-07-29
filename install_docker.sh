#!/bin/bash

echo "Starting Docker installation and setup..."

# Uninstall all conflicting packages
echo "Removing conflicting packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# Update the apt package index and install necessary packages
echo "Updating package index and installing necessary packages..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Create the keyrings directory if it doesn't exist
echo "Creating keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
echo "Downloading Docker's official GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's apt repository to sources list
echo "Adding Docker's apt repository to sources list..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again
echo "Updating package index again..."
sudo apt-get update

# Install the latest version of Docker
echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify the Docker Engine installation by running the hello-world image
echo "Verifying Docker Engine installation..."
sudo docker run hello-world

# Create the docker group
echo "Creating Docker group..."
sudo groupadd docker

# Add the current user to the docker group
echo "Adding the current user to the Docker group..."
sudo usermod -aG docker $USER

# Activate the changes to groups
echo "Activating group changes..."
newgrp docker <<EOF
source ./post_newgrp.sh
EOF
