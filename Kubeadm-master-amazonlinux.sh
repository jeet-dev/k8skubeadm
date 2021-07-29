#!/bin/sh

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet


sudo cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 
net.ipv4.ip_forward = 1
EOF


sudo sysctl --system

sudo sudo setenforce 0
sudo sed -i ‘s/^SELINUX=enforcing$/SELINUX=permissive/’ /etc/selinux/config

sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter


# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

lsmod | grep br_netfilter

sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.2-3.3.el7.x86_64.rpm

containerd --version

sudo mkdir -p /etc/containerd

sudo containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd


if [ "$1" == "w-docker" ]; 
then
   sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-20.10.7-3.el7.x86_64.rpm 
   sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-20.10.7-3.el7.x86_64.rpm 
fi


if [ "$2" == "master" ]; 
then
 echo "Initializing kubeadm"
  sudo hostnamectl set-hostname master-node
  sudo kubeadm config images pull
  sudo kubeadm init
fi