#!/bin/bash
## Install docker
apt update && apt install -y -qq docker.io

## Install kubernetes services
apt update && apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update && apt install -y kubelet kubeadm kubectl

systemctl enable kubelet

## Disable swap
swapoff -a # Need to make permanent edit in /etc/fstab
#sed -i /swap/s/^/#/ /etc/fstab # Should disable swap permanently, VERIFY!

## Set up the initial cluster, pod-network-cidr is for flannel
kubeadm init --pod-network-cidr=10.244.0.0/16 --node-name $HOSTNAME

## Set up configuration for kubectl to the cluster
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

## Enable autocompletion for kubectl
echo "source <(kubectl completion bash)" >> ~/.bashrc

## Install flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml