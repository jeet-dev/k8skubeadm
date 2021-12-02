
https://docs.projectcalico.org/manifests/calico.yaml 

for RHEL 7.6+ 

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-1.el7_6.noarch.rpm

yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.4.9-3.1.el7.x86_64.rpm

yum install -y  https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.15-3.el7.x86_64.rpm

yum install -y  https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.15-3.el7.x86_64.rpm

sudo yum install -y kubelet-1.21.5 kubeadm-1.21.5 kubectl-1.21.5 


//yum install kubelet-1.21.1-0 kubeadm-1.21.1-0 kubectl-1.21.1-0 ( for 1.21.1) version

sudo yum -y install yum-versionlock

sudo yum versionlock add kubelet kubeadm kubectl
