#!/bin/bash

# Create a Docker volume for Portainer data
echo "Creating Docker volume for Portainer data..."
docker volume create portainer_data

# Deploy Portainer
echo "Deploying Portainer..."
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

echo "Docker installation and Portainer deployment completed successfully."
