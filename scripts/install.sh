#!/bin/bash

export AZURE_SUBSCRIPTION_ID=$1
export AZURE_CLIENT_ID=$2
export AZURE_SECRET=$3
export AZURE_TENANT=$4
export USERNAME=$5
export SSH_PRIVATE_DATA=$6

echo $(date) " - Starting Script"

# Install EPEL repository
echo $(date) " - Installing SSH data"

mkdir -p /home/${USERNAME}/.ssh/
echo ${SSH_PRIVATE_DATA} | base64 --d > /home/${USERNAME}/.ssh/id_rsa 
chown ${USERNAME} /home/${USERNAME}/.ssh/id_rsa
chmod 600 /home/${USERNAME}/.ssh/id_rsa 

echo $(date) " - SSH data successfully installed"

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
#pip install boto3

#echo $(date) " - Checkout Git Repo"

yum -y install git
yum -y install tmux

echo $(date) " - Install Credentials für Azure"

mkdir -p /home/${USERNAME}/.azure/
cat > ~/.azure/credentials <<EOF
[default]
subscription_id=${AZURE_SUBSCRIPTION_ID}
client_id=${AZURE_CLIENT_ID}
secret=${AZURE_SECRET}
tenant=${AZURE_TENANT}
EOF

chown ${USERNAME} /home/${USERNAME}/.azure/credentials

echo $(date) " - Script complete"
