#!/bin/sh

sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service
sudo service docker start
sudo usermod -a -G docker ec2-user


sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


sudo cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system


sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubelet kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet

sudo yum install -y kubeadm
echo "source <(kubectl completion bash)" >> ~/.bashrc
