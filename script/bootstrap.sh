#!/usr/bin/env bash

# Install ansible using pip3
python3 -m pip install ansible

# Generate keypair and distribute it to controller and managed node so ansuser can run playbooks using the keys
ssh-keygen -b 2048 -t rsa -f /home/ansuser/.ssh/id_rsa -q -N ""

for host in anscontroller ansubuntu ansalpine; do
        echo "++ Copying Key to ${host}"
        sshpass -p 'password123' ssh-copy-id -i /home/ansuser/.ssh/id_rsa -o "StrictHostKeyChecking=no" ansuser@$host
done

# Generate sample setup
mkdir sample_project
cd sample_project

# Ansible.cfg file
echo -e "++ Generating ansible.cfg file\n"
echo -e "[defaults]
inventory = hosts
host_key_checking = False
nocows = 1" > ansible.cfg

# Hosts file
echo -e "++ Generating hosts file file\n"
echo -e "[servers]
anscontroller 
ansubuntu 
ansalpine
anscentos" > hosts

# Playbook file
echo -e "++ Generating sample playbook\n"
echo -e "- name: My first play
  hosts: servers
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
      msg: Hello world" > playbook.yml

# Generating sample playbook
ansible servers -i /home/ansuser/sample_project/hosts -m shell -a "cat /etc/os-release | grep -i PRETTY_NAME" --key-file /home/ansuser/.ssh/id_rsa -o