#!/bin/bash

# Copy HTML to the NFS shared volume
sudo cp /vagrant/index.html /var/data/index.html

# Drain master so it only manages, no containers run on it
sudo docker node update --availability drain $(hostname)

# Deploy the service with 15 replicas using the shared NFS volume
sudo docker service create \
  --name web-app \
  --replicas 15 \
  --publish 80:80 \
  --mount type=bind,src=/var/data,dst=/usr/share/nginx/html \
  nginx:alpine
