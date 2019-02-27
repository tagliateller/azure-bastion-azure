#!/bin/bash

export AWSACCESSKEYID=$1
export AWSSECRETACCESSKEY=$2 

echo $(date) " - Starting Script"

# Install EPEL repository
echo $(date) " - Installing EPEL"

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

echo $(date) " - EPEL successfully installed"

echo $(date) " - Install Pip"

curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py

echo $(date) " - Install Ansible"

pip install ansible
pip install boto3

echo $(date) " - Checkout Git Repo"

yum -y install git

echo $(date) " - Script complete"
