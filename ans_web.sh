#!/bin/bash
sudo su -
sudo yum -y update && sudo yum install -y python
sudo useradd cada -s /bin/bash -m
sudo echo 'cada:cada' | chpasswd
sudo echo 'cada ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
