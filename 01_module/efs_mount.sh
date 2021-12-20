#!/bin/bash
sudo cat > /home/ec2-user/.ssh/id_rsa << EOF



id_rsa private key






EOF
sudo chmod 600 /home/ec2-user/.ssh/id_rsa
sudo su -
cp /home/ec2-user/.ssh/id_rsa /root/.ssh/id_rsa
chmod 600 /root/id_rsa
chown -RH ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
amazon-linux-extras install ansible2 -y
cd /root

#boto/python 설치

sudo cat > install.yml <<-EAF
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

#aws에 연결하기 위한 id/key
aws configure set aws_access_key_id AKIA2UICVQQC5IEUUYLJ
aws configure set aws_secret_access_key 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
cd /root
sudo yum install -y git
sudo git clone https://github.com/jump99500/TeamCada_Ansible.git /root/ansible
cp /root/.ssh/id_rsa /root/ansible
cd ansible
ansible-playbook web.yaml
ansible-playbook was.yaml
ansible-playbook was_efs_mount.yaml
