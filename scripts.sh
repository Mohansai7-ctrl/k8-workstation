#!/bin/bash


# need to create below to create a kubernetes workstation:
# 1)Extend the volume of the server
# 2) install the docker
# 3) install the kubectl command line tool
# 4) install the cluster manager eksctl command line tool
# 5) aws configure  ----> this is done in provider .tf


#1)Extend the volume of the server
df -hT
lsblk
name=$(lsblk -dn -o NAME | head -n 1)
growpart /dev/$name 4
# growpart /dev/xvda 4  # xvda for t2.micro for t3.micro it is nvme
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
df -hT

#Uninstalling the older docker version if exists:
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

#2) installing the docker:
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo -y
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
sudo usermod -aG docker ec2-user
# echo "Please relogin to this server/workstation to reflect the group changes"


#3) install the kubectl command line tool
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl
kubectl version
#kubectl version --client


#4) install the cluster manager eksctl command line tool
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH


curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
mv /tmp/eksctl /usr/local/bin


# 5) aws configure:
# 5-i) installing aws cli:

# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install

# # 5-2)passing the aws creds from terraform variables(run time) to shell here:
# AWS_ACCESS_KEY_ID=$1
# AWS_SECRET_ACCESS_KEY=$2
# AWS_REGION=$3

# echo "aws_access key is $AWS_ACCESS_KEY_ID"
# echo "aws_secret access key is $AWS_SECRET_ACCESS_KEY"
# echo "aws_region is $AWS_REGION"

# # 5-3) Configuring the aws:

# aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
# aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
# aws configure set aws_region "$AWS_REGION"
# aws configure set output json







