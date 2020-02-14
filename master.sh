sysctl net.bridge.bridge-nf-call-iptables=1

apt-get -y update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update && apt-get install -y git openjdk-8-jre docker.io kubeadm
apt-get install ubuntu-desktop

cp /vagrant/daemon.json /etc/docker
systemctl restart docker

kubeadm reset -f
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(ifconfig enp0s9|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') > /vagrant/kube.txt

rm -rf /home/vagrant/.kube
mkdir /home/vagrant/.kube && cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config && chown -R vagrant:vagrant /home/vagrant/.kube
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml"
su - vagrant -c "kubectl get nodes"

# Installing addon manager
mkdir -p /etc/kubernetes/addons
cp /vagrant/addon-manager/kube-addon-manager.yaml /etc/kubernetes/manifests
cp /home/vagrant/.kube/config /etc/srv/kubernetes/addon-manager/kubeconfig

#su - vagrant -c "kubectl apply -f /vagrant/kube-addon-manager.yml"
