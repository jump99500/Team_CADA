#!/bin/bash
sudo su -
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum update
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2


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



