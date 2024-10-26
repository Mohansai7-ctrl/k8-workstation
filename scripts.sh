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


#2) installing the docker:
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo -y
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
usermod -aG docker ec2-user


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


# 5) aws configure  ----> this is done in provider .tf






