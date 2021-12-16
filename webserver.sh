#!/bin/bash
sudo su -
sudo sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum update
sudo amazon-linux-extras list
sudo amazon-linux-extras install -y ansible2


sudo cat > /etc/ansible/ansible.cfg << EOQ
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

sudo cat > /home/ec2-user/webserver.yml <<-EOF 
---
- name: Install and start Apache web service
  hosts: web
  gather_facts: false
  ignore_errors: true
  vars:
    web_pkg: httpd
    firewall_pkg: firewalld
    web_service: httpd
    firewall_service: firewalld
    python_pkg: python3-PyMYSQL
    rule: http

  tasks:
  - name: Install up to date packages
    yum: 
      name: 
        - "{{ web_pkg }}"
        - "{{ firewall_pkg }}"
        - "{{ python_pkg }}"
      state: latest

  - name: The {{ firewall_service }} service is started and enabled
    service:
      name: "{{ firewall_service }}"
      enabled: true
      state: started
  - name: The {{ web_service }} service ise started and enabled
    service:
      name: "{{ web_service }}"
      enabled: true
      state: started

  - name: Create index.html file
    copy:
      content: "Bespin website index file"
      dest: /var/www/html/index.html

  - name: The firewall port for {{ rule }} is open
    firewalld:
      service: "{{ rule }}"
      permanent: true
      immediate: true
      state: enabled

- name: Verify the Apache service
  hosts: localhost
  become: false
  tasks:
    - name: Ensure the webserver is reachable
      uri:
        url: http://192.168.2.10
        status_code: 200
EOF

sudo ansible-playbook webserver.yml