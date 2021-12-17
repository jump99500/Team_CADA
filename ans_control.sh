#!/bin/bash
sudo su -
sudo yum -y update && sudo yum install -y python
sudo yum install wget -y
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
systemctl restart sshd
