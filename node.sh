sysctl net.bridge.bridge-nf-call-iptables=1

apt-get -y update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update && apt-get install -y git openjdk-8-jre docker.io kubeadm

cp /vagrant/daemon.json /etc/docker
systemctl restart docker

kubeadm reset -f

$(cat /vagrant/kube.txt | grep 'kubeadm join' | awk '{ print $1, $2, $3, $4, $5 }'; cat /vagrant/kube.txt | grep 'discovery' | awk '{ print $1, $2 }')
