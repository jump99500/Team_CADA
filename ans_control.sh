#!/bin/bash
sudo su -
apt-get update
apt-get install apt-transport-https wget gnupg
apt-add-repository ppa:ansible/ansible
useradd cada -s /bin/bash -m
echo 'cada:cada' | chpasswd
echo 'cada ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
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
