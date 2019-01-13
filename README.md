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

# Doing

export AWS_PROFILE=myaccount

Kopieren Inventory und Prereq in das entsprechende Verzeichnis entspr. Step 0:

## Step 0

[root@bastion openshift-cluster]# ansible-playbook -i inventory.yml prerequisites.yml -e @provisioning_vars.yml
 [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'


PLAY [localhost] ********************************************************************************************************************************************

TASK [openshift_aws : query azs] ****************************************************************************************************************************
ok: [localhost]

TASK [openshift_aws : fail] *********************************************************************************************************************************
skipping: [localhost]

TASK [openshift_aws : Create AWS VPC] ***********************************************************************************************************************
changed: [localhost]

TASK [openshift_aws : Sleep to avoid a race condition when creating the vpc] ********************************************************************************
Pausing for 5 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [localhost]

TASK [openshift_aws : assign the vpc igw] *******************************************************************************************************************
changed: [localhost]

TASK [openshift_aws : assign the vpc subnets] ***************************************************************************************************************
changed: [localhost] => (item={u'cidr': u'172.31.48.0/20', u'az': u'us-east-1c'})

TASK [openshift_aws : Grab the route tables from our VPC] ***************************************************************************************************
ok: [localhost]

TASK [openshift_aws : update the route table in the vpc] ****************************************************************************************************
changed: [localhost]

PLAY [localhost] ********************************************************************************************************************************************

TASK [openshift_aws : Add the public keys for the users] ****************************************************************************************************
skipping: [localhost]

PLAY [localhost] ********************************************************************************************************************************************

TASK [openshift_aws : Fetch the VPC for the vpc.id] *********************************************************************************************************
ok: [localhost]

TASK [openshift_aws : create the node group sgs] ************************************************************************************************************
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 22, u'from_port': 22, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 65535, u'from_port': 1, u'group_name': u'originpoc', u'proto': u'all'}], u'name': u'originpoc', u'desc': u'originpoc default'}, 'key': u'default'})
changed: [localhost] => (item={'value': {u'name': u'originpoc_compute', u'desc': u'originpoc compute node instances'}, 'key': u'compute'})
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_master', u'desc': u'originpoc master instances'}, 'key': u'master'})
changed: [localhost] => (item={'value': {u'name': u'originpoc_etcd', u'desc': u'originpoc etcd instances'}, 'key': u'etcd'})
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 32000, u'from_port': 30000, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_infra', u'desc': u'originpoc infra node instances'}, 'key': u'infra'})

TASK [openshift_aws : create the k8s sgs for the node group] ************************************************************************************************
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 22, u'from_port': 22, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 65535, u'from_port': 1, u'group_name': u'originpoc', u'proto': u'all'}], u'name': u'originpoc', u'desc': u'originpoc default'}, 'key': u'default'})
changed: [localhost] => (item={'value': {u'name': u'originpoc_compute', u'desc': u'originpoc compute node instances'}, 'key': u'compute'})
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_master', u'desc': u'originpoc master instances'}, 'key': u'master'})
changed: [localhost] => (item={'value': {u'name': u'originpoc_etcd', u'desc': u'originpoc etcd instances'}, 'key': u'etcd'})
changed: [localhost] => (item={'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 32000, u'from_port': 30000, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_infra', u'desc': u'originpoc infra node instances'}, 'key': u'infra'})

TASK [openshift_aws : tag sg groups with proper tags] *******************************************************************************************************
changed: [localhost] => (item={u'ip_permissions': [], '_ansible_parsed': True, u'description': u'originpoc default for k8s', u'tags': {}, '_ansible_item_result': True, u'group_name': u'originpoc_k8s', u'ip_permissions_egress': [{u'prefix_list_ids': [], u'ip_ranges': [{u'cidr_ip': u'0.0.0.0/0'}], u'ip_protocol': u'-1', u'user_id_group_pairs': [], u'ipv6_ranges': []}], '_ansible_item_label': {'key': u'default', 'value': {u'rules': [{u'to_port': 22, u'from_port': 22, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 65535, u'from_port': 1, u'proto': u'all', u'group_name': u'originpoc'}], u'name': u'originpoc', u'desc': u'originpoc default'}}, '_ansible_no_log': False, 'item': {'key': u'default', 'value': {u'rules': [{u'to_port': 22, u'from_port': 22, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 65535, u'from_port': 1, u'proto': u'all', u'group_name': u'originpoc'}], u'name': u'originpoc', u'desc': u'originpoc default'}}, u'changed': True, 'failed': False, u'invocation': {u'module_args': {u'profile': None, u'rules_egress': None, u'description': u'originpoc default for k8s', u'purge_rules': True, u'tags': None, u'rules': None, u'purge_tags': True, u'ec2_url': None, u'purge_rules_egress': True, u'aws_secret_key': None, u'aws_access_key': None, u'name': u'originpoc_k8s', u'security_token': None, u'region': u'us-east-1', u'state': u'present', u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': None, u'validate_certs': True}}, u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': u'sg-0e8c25ab059a4758a', '_ansible_ignore_errors': None, u'owner_id': u'725031456394'})
changed: [localhost] => (item={u'ip_permissions': [], '_ansible_parsed': True, u'description': u'originpoc compute node instances for k8s', u'tags': {}, '_ansible_item_result': True, u'group_name': u'originpoc_compute_k8s', u'ip_permissions_egress': [{u'prefix_list_ids': [], u'ip_ranges': [{u'cidr_ip': u'0.0.0.0/0'}], u'ip_protocol': u'-1', u'user_id_group_pairs': [], u'ipv6_ranges': []}], '_ansible_item_label': {'key': u'compute', 'value': {u'name': u'originpoc_compute', u'desc': u'originpoc compute node instances'}}, '_ansible_no_log': False, 'item': {'key': u'compute', 'value': {u'name': u'originpoc_compute', u'desc': u'originpoc compute node instances'}}, u'changed': True, 'failed': False, u'invocation': {u'module_args': {u'profile': None, u'rules_egress': None, u'description': u'originpoc compute node instances for k8s', u'purge_rules': True, u'tags': None, u'rules': None, u'purge_tags': True, u'ec2_url': None, u'purge_rules_egress': True, u'aws_secret_key': None, u'aws_access_key': None, u'name': u'originpoc_compute_k8s', u'security_token': None, u'region': u'us-east-1', u'state': u'present', u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': None, u'validate_certs': True}}, u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': u'sg-01bb2eb856bc3304c', '_ansible_ignore_errors': None, u'owner_id': u'725031456394'})
changed: [localhost] => (item={u'ip_permissions': [], '_ansible_parsed': True, u'description': u'originpoc master instances for k8s', u'tags': {}, '_ansible_item_result': True, u'group_name': u'originpoc_master_k8s', u'ip_permissions_egress': [{u'prefix_list_ids': [], u'ip_ranges': [{u'cidr_ip': u'0.0.0.0/0'}], u'ip_protocol': u'-1', u'user_id_group_pairs': [], u'ipv6_ranges': []}], '_ansible_item_label': {'key': u'master', 'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_master', u'desc': u'originpoc master instances'}}, '_ansible_no_log': False, 'item': {'key': u'master', 'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_master', u'desc': u'originpoc master instances'}}, u'changed': True, 'failed': False, u'invocation': {u'module_args': {u'profile': None, u'rules_egress': None, u'description': u'originpoc master instances for k8s', u'purge_rules': True, u'tags': None, u'rules': None, u'purge_tags': True, u'ec2_url': None, u'purge_rules_egress': True, u'aws_secret_key': None, u'aws_access_key': None, u'name': u'originpoc_master_k8s', u'security_token': None, u'region': u'us-east-1', u'state': u'present', u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': None, u'validate_certs': True}}, u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': u'sg-08afd0eace7040130', '_ansible_ignore_errors': None, u'owner_id': u'725031456394'})
changed: [localhost] => (item={u'ip_permissions': [], '_ansible_parsed': True, u'description': u'originpoc etcd instances for k8s', u'tags': {}, '_ansible_item_result': True, u'group_name': u'originpoc_etcd_k8s', u'ip_permissions_egress': [{u'prefix_list_ids': [], u'ip_ranges': [{u'cidr_ip': u'0.0.0.0/0'}], u'ip_protocol': u'-1', u'user_id_group_pairs': [], u'ipv6_ranges': []}], '_ansible_item_label': {'key': u'etcd', 'value': {u'name': u'originpoc_etcd', u'desc': u'originpoc etcd instances'}}, '_ansible_no_log': False, 'item': {'key': u'etcd', 'value': {u'name': u'originpoc_etcd', u'desc': u'originpoc etcd instances'}}, u'changed': True, 'failed': False, u'invocation': {u'module_args': {u'profile': None, u'rules_egress': None, u'description': u'originpoc etcd instances for k8s', u'purge_rules': True, u'tags': None, u'rules': None, u'purge_tags': True, u'ec2_url': None, u'purge_rules_egress': True, u'aws_secret_key': None, u'aws_access_key': None, u'name': u'originpoc_etcd_k8s', u'security_token': None, u'region': u'us-east-1', u'state': u'present', u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': None, u'validate_certs': True}}, u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': u'sg-098edd8ab6bfdd2fa', '_ansible_ignore_errors': None, u'owner_id': u'725031456394'})
changed: [localhost] => (item={u'ip_permissions': [], '_ansible_parsed': True, u'description': u'originpoc infra node instances for k8s', u'tags': {}, '_ansible_item_result': True, u'group_name': u'originpoc_infra_k8s', u'ip_permissions_egress': [{u'prefix_list_ids': [], u'ip_ranges': [{u'cidr_ip': u'0.0.0.0/0'}], u'ip_protocol': u'-1', u'user_id_group_pairs': [], u'ipv6_ranges': []}], '_ansible_item_label': {'key': u'infra', 'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 32000, u'from_port': 30000, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_infra', u'desc': u'originpoc infra node instances'}}, '_ansible_no_log': False, 'item': {'key': u'infra', 'value': {u'rules': [{u'to_port': 80, u'from_port': 80, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': u'8443', u'from_port': u'8443', u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}, {u'to_port': 32000, u'from_port': 30000, u'cidr_ip': u'0.0.0.0/0', u'proto': u'tcp'}], u'name': u'originpoc_infra', u'desc': u'originpoc infra node instances'}}, u'changed': True, 'failed': False, u'invocation': {u'module_args': {u'profile': None, u'rules_egress': None, u'description': u'originpoc infra node instances for k8s', u'purge_rules': True, u'tags': None, u'rules': None, u'purge_tags': True, u'ec2_url': None, u'purge_rules_egress': True, u'aws_secret_key': None, u'aws_access_key': None, u'name': u'originpoc_infra_k8s', u'security_token': None, u'region': u'us-east-1', u'state': u'present', u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': None, u'validate_certs': True}}, u'vpc_id': u'vpc-0fd49a24a162bde31', u'group_id': u'sg-0f901d4e5b4ea618a', '_ansible_ignore_errors': None, u'owner_id': u'725031456394'})

PLAY [Create iam role] **************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [localhost]

TASK [create iam role] **************************************************************************************************************************************

TASK [openshift_aws : Create an iam role] *******************************************************************************************************************
changed: [localhost] => (item=master)
changed: [localhost] => (item=compute)
changed: [localhost] => (item=infra)

TASK [openshift_aws : create an iam policy] *****************************************************************************************************************
changed: [localhost] => (item=master)
changed: [localhost] => (item=compute)
changed: [localhost] => (item=infra)

PLAY RECAP **************************************************************************************************************************************************
localhost                  : ok=14   changed=9    unreachable=0    failed=0

[root@bastion openshift-cluster]#

## Step 1

[root@bastion openshift-cluster]# ansible-playbook -i inventory.yml build_ami.yml -e @provisioning_vars.yml
 [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'


PLAY [localhost] ********************************************************************************************************************************************

TASK [Require openshift_aws_base_ami] ***********************************************************************************************************************
skipping: [localhost]

TASK [Alert user to variables needed and their values - {{ item.name }}] ************************************************************************************
ok: [localhost] => (item={u'msg': u'openshift_aws_clusterid=originpoc', u'name': u'openshift_aws_clusterid'}) => {
    "msg": "openshift_aws_clusterid=originpoc"
}
ok: [localhost] => (item={u'msg': u'openshift_aws_region=us-east-1', u'name': u'openshift_aws_region'}) => {
    "msg": "openshift_aws_region=us-east-1"
}

PLAY [localhost] ********************************************************************************************************************************************

TASK [openshift_aws : include_tasks] ************************************************************************************************************************
included: /var/lib/waagent/custom-script/download/0/openshift-ansible/roles/openshift_aws/tasks/vpc_and_subnet_id.yml for localhost

TASK [openshift_aws : query vpc] ****************************************************************************************************************************
ok: [localhost]

TASK [openshift_aws : debug vpcout] *************************************************************************************************************************
skipping: [localhost]

TASK [openshift_aws : fetch the subnet ids] *****************************************************************************************************************
ok: [localhost] => (item=us-east-1c)

TASK [openshift_aws : debug subnetout] **********************************************************************************************************************
skipping: [localhost]

TASK [openshift_aws : create instance for ami creation] *****************************************************************************************************
changed: [localhost]

TASK [openshift_aws : fetch newly created instances] ********************************************************************************************************
ok: [localhost]

TASK [openshift_aws : wait for ssh to become available] *****************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "elapsed": 300, "msg": "Timeout when waiting for search string OpenSSH in 34.237.145.147:22"}
        to retry, use: --limit @/var/lib/waagent/custom-script/download/0/openshift-ansible/playbooks/aws/openshift-cluster/build_ami.retry

PLAY RECAP **************************************************************************************************************************************************
localhost                  : ok=6    changed=1    unreachable=0    failed=1

[root@bastion openshift-cluster]#
