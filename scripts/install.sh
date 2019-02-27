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
pip install boto

echo $(date) " - Checkout Git Repo"

yum -y install git

git clone https://github.com/tagliateller/openshift-ansible.git openshift-ansible
cd openshift-ansible
git checkout release-3.11

#https://github.com/openshift/openshift-ansible/tree/release-3.11/playbooks/aws
		
#~/.aws/credentials 
		
#[myaccount]
#aws_access_key_id = <Your access_key here>
#aws_secret_access_key = <Your secret acces key here>

echo $(date) " - Create AWS Credentials"

mkdir -p ~/.aws/
cat > ~/.aws/credentials <<EOF
[myaccount]
aws_access_key_id = ${AWSACCESSKEYID}
aws_secret_access_key = ${AWSSECRETACCESSKEY}
EOF
 
echo $(date) " - Script Complete"

