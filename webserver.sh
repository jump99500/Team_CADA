#!/bin/bash
sudo su -
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum update
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2