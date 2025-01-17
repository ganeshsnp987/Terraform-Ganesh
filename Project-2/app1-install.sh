#!/bin/bash
yum install ansible
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm -y
yum install ansible -y

useradd ansuser
echo 111 | passwd --stdin ansuser
echo 111 | passwd --stdin root
echo "ansuser  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
PermitRootLogin yes >> /etc/ssh/sshd_config
systemctl restart sshd
service sshd restart

mkdir /home/ansuser/ansible/
echo "[target]" >> /home/ansuser/ansible/inventory
echo "node1" >> /home/ansuser/ansible/inventory
echo "node2" >> /home/ansuser/ansible/inventory
echo "node3" >> /home/ansuser/ansible/inventory
echo "[target:vars]" >> /home/ansuser/ansible/inventory
echo "ansible_user=ansuser" >> /home/ansuser/ansible/inventory
echo "ansible_password=111" >> /home/ansuser/ansible/inventory
echo "ansible_connection=ssh" >> /home/ansuser/ansible/inventory
chown ansuser:ansuser /home/ansuser/ansible

echo "[defaults]" >> /home/ansuser/ansible/ansible.cfg
echo "inventory = /home/ansuser/ansible/inventory" >> /home/ansuser/ansible/ansible.cfg
echo "host_key_checking = false" >> /home/ansuser/ansible/ansible.cfg
echo "[privilege_escalation]" >> /home/ansuser/ansible/ansible.cfg
echo "become = true" >> /home/ansuser/ansible/ansible.cfg
echo "become_user = root" >> /home/ansuser/ansible/ansible.cfg
echo "become_ask_pass = false" >> /home/ansuser/ansible/ansible.cfg
chown -R ansuser:ansuser /home/ansuser
