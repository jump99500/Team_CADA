resource "aws_instance" "ansible" {
    ami = "ami-0263588f2531a56bd"
    instance_type = "t2.micro"
    key_name = aws_key_pair.id_rsa.id
    vpc_security_group_ids = [aws_security_group.security_ansible.id]
    subnet_id = aws_subnet.ansible_subnet.id
    iam_instance_profile = aws_iam_instance_profile.profile_ansible.name   ###
    user_data = <<EOF
#!/bin/bash
sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
systemctl restart sshd
apt install software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt update
apt install ansible -y
apt install python-boto3 -y
cd /home/ubuntu
su ubuntu -c "git clone [github url for ansible]"
su ubuntu -c "echo '' > Ansible/aws_key_pair.id_rsa.id"
su ubuntu -c "chmod 600 Ansible/aws_key_pair.id_rsa.id"
EOF

    tags = {
        Name = "ansible"
    }
}

resource "aws_iam_role" "role_ansible" {
  name = "role-ansible"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy_ansible" {
  name = "cd_policy_ansible"
  role = aws_iam_role.role_ansible.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_instance_profile" "profile_ansible" {
  name = "cd-profile-ansible"
  role = aws_iam_role.role_ansible.name
}

