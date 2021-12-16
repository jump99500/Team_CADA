#!/bin/bash
sudo su -
sudo yum -y update && sudo yum install -y python
sudo yum install wget -y
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
cat >> /etc/ansible/hosts << EOD
[web]
192.168.2.10
[was]
192.168.4.10
EOD
cat > /etc/ansible/ansible.cfg << EOQ
[defaults]
remote_port = 22
inventory = /etc/ansible/hosts
remote_user = cada
ask_pass = false
[privilege_escalation]
become = true
become_method = sudo
become_user = root
become_ask_pass = false
EOQ
systemctl restart sshd
