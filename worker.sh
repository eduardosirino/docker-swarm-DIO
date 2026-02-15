#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y nfs-common

# Mount NFS volume from master
sudo mkdir -p /var/data
sudo mount 192.168.56.200:/var/data /var/data
echo "192.168.56.200:/var/data /var/data nfs defaults 0 0" | sudo tee -a /etc/fstab

sudo docker swarm join --token "$(cat /vagrant/token.txt)" 192.168.56.200:2377
