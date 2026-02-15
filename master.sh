#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo docker swarm init --advertise-addr=192.168.56.200
sudo docker swarm join-token worker -q > /vagrant/token.txt

# NFS Server setup
sudo apt-get install -y nfs-server
sudo mkdir -p /var/data
sudo chmod 777 /var/data
echo "/var/data *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
sudo exportfs -ar
sudo systemctl enable nfs-server
sudo systemctl start nfs-server
