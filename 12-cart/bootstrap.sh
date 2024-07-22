#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
component=$1
environment=$2

# Update the package index
yum update -y

# Install EPEL release if not already installed
yum install epel-release -y

# Install Python 3.11 and development tools
yum install python3.11 python3.11-devel python3.11-pip -y

# Upgrade pip
python3.11 -m pip install --upgrade pip

# Install required Python packages
python3.11 -m pip install botocore boto3

# Install Python 3.11 and development tools
yum install ansible -y

# Create a symbolic link to ensure Ansible uses the correct Python interpreter
alternatives --set python3 /usr/bin/python3.11

# Run Ansible pull
ansible-pull -U https://github.com/yjash0801/mechanoidstore-ansible-roles-tf.git -e component=$component -e env=$environment main-tf.yaml

# component=$1
# environment=$2 #dont use env here, it is reserved in linux
# yum install python3.11-devel python3.11-pip -y
# pip3.11 install ansible botocore boto3
# python3.11 -m pip install --upgrade pip
# pip install --upgrade ansible
# ansible-pull -U https://github.com/yjash0801/mechanoidstore-ansible-roles-tf.git -e component=$component -e env=$environment main-tf.yaml