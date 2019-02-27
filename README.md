# azure-bastion

az login --service-principal -u http://changeme -p password_changeme --tenant changeme

az group create --name changeme --location eastus

vi azuredeploy.parameters.json

az group deployment create -g changeme --name changeme --template-uri https://raw.githubusercontent.com/tagliateller/azure-bastion/azuredeploy.json --parameters @./azuredeploy.parameters.json

az group delete -y --name changeme

# Parameters

vi azuredeploy.parameters.json

        "sshPublicKey": {
            "value": "ssh-rsa AA...ZZ vagrant@localhost.localdomain"
        },

# AWS 

https://github.com/openshift/openshift-ansible/tree/release-3.11/playbooks/aws