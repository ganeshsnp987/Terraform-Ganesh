#!/bin/bash
useradd ansuser
echo 111 | passwd --stdin ansuser
echo "ansuser  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
PermitRootLogin yes >> /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ansuser
