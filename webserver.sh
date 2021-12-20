#!/bin/bash
sudo su -
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum update
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2
sudo cat > /home/ec2-user/id_rsa << EOF
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
EOF

sudo cd /home/ec2-user

#boto/python 설치

sudo cat >> /home/ec2-user/install.yml <<-EAF
---
- hosts: localhost
  become: yes

  tasks:
    - name: install pip
      yum:
        name:
          - python-pip
          - python3-pip
        state: latest

    - name: install boto
      pip:
        name:
          - boto
          - boto3
EAF

sudo ansible-playbook install.yml

#ansible.cfg 만들기 

sudo cat >> /home/ec2-user/ansible.cfg<<-EBF
[defaults]
inventory = ./aws_ec2.yml
host_key_checking = False
pipelining = True
roles_path = ./roles
# forks = 1000
remote_user = ec2-user
private_key_file = /home/ec2-user/id_rsa

[inventory]
enable_plugins = aws_ec2

[privilege_escalation]
become = true
become_method = sudo
become_user = root
become_ask_pass = false
EBF

#aws_ec2.yml 만들기

sudo cat >> /home/ec2-user/aws_ec2.yml <<-ECF
plugin: aws_ec2

boto_profile: default

regions:
  - ap-northeast-2
filters:
  instance-state-name: running

compose:
  ansible_host: private_ip_address

hostnames:
  - private-ip-address

keyed_groups:
  - key: tags
ECF

#aws에 연결하기 위한 id/key

aws configure set aws_access_key_id AKIA2UICVQQCX7WTUEK3
aws configure set aws_secret_access_key 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


#ansible 변수파일(기초) 생성

sudo cat >> /home/ec2-user/variable.yml <<-EDF
project_name: 'cd'
project_region: 'ap-northeast-2'
key_name: 'id_rsa'
EDF



