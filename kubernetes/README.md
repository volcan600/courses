# Kubernetes

## Module 1: Getting Started

### 1.1 Understanding Kubernetes Core Functions
* It is composed for replica, deployment, pod, container, api, etc resources

### 1.2 Understanding Kubernetes API Objects

```bash
# Everything running on the kube-system namespace
kubectl get pods -n kube-system
```

```bash
# Everything is define in the API 
kubectl api-resources | less
```

```bash
kubectl api-versions
```

### 1.3 Understanding Kubernetes Architecture

#### Understanding the Master Node
* kube-apiserver: front-end of the cluster that services REST operations and connects to the etcd database
* kube-scheduler: schedules Pods on specific nodes based on labels, taints, and tolerations set of the Pods
* etcd: a B+tree key-value store that keeps the current cluster state
* kube-controller-manager: interacts with outside cloud managers
* Different optional add-ons
  * DNS
  * Dashboard
  * Cluster level resource monitoring
  * Cluster level logging

#### Understanding the Worker Nodes
* kubelet: passes requests to the container engine to ensure that Pods are available
* kube-proxy: runs on every node and uses iptables to provide an interface to connect to kubernetes components
* container runtime: takes care of actually running the containers
* supervisord: monitors and guarantees the availability of the kubelet and docker processses
* network agent: implements a software defined networking solution, such as weave
* logging: the CNCF project Fluentd is used for unified logging in the cluster. A Fluentd agent must be install on the k8s nodes

### 2.2 Using kubernetes in Public Cloud
* AWS
* Google Cloud
* Digital Ocean

### 2.3 Using minikube
* Good for learning

### 3.1 Understanding Cluster Node Requirements
* For reference, use https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
* To set up a kubernetes on-premise cluster, **kubeadm** is used
* You'll need a mimimum of one node, for the setup used in this course you'll need 3 nodes
* Use Centos 7.x or Ubuntu for best support
* The control node needs 2 CPUs
* All nodes need 1GiB a test environment, a minimum of 2GiB or (much) more is required for production environments
* Install without using swap space
  * **free -m**
  * **vim /etc/fstab**
  * look up for the swap line and comment it.
* Disable the firewall

#### Course Cluster Specs
* control.example.com
  * 2 CPUs
  * 2 GiB RAM
  * 192.168.100.210/24
* worker1.example.com
  * 1 GiB RAM
  * 192.168.100.211/24
* worker2.example.com
  * 1 GiB RAM
  * 192.168.100.212/24
* worker3.example.com
  * 1 GiB RAM
  * 192.168.100.213/24
* All using CentOS 7.x with a minimal installation pattern

#### Software Installation
* Before starting installation, you need a container runtime
* Different runtimes are supported, in this course we'll use **docker**
* To make installation easy, use **git clone https://github.com/sandervanvugt/cka** which provides 2 scripts
  * **setup-docker.sh** installs the Docker container runtime
  * **setup-kubetools.sh** installs the kubernetes tools
* As root, run these scripts on all nodes
* On all nodes, ensure that the docker service is enabled before continuing

```bash
sudo yum install -y vim git bash-completion
```

```bash
git clone https://github.com/sandervanvugt/cka
```
* Run the script on master and all nodes
```bash
# Modify the script setup-docker.sh script
cd ./cka
vim ./setup-docker.sh
sudo ./setup-docker.sh
```

* Run the script on master and all nodes
```bash
sudo ./setup-kubetools.sh
```

### 3.2 Using kubeadm to Build a Cluster

#### Setting up the Control Node
* On all nodes: disable swap
* On all nodes: disable firewall or open appropriate ports in the firewall
* On all nodes: set up hostname, full name and aliases resolving through /etc/hosts
* On control: **kubeadm init**
* Take a note of the **kubeadm join** command that is shown after initializing the cluster

#### Starting the Cluster
* Create the client configuration file by applying the following steps as as regular user account
  * **mkdir -p $HOME/.kube**
  * **sudo cp -l /etc/kubernetes/admin.conf $HOME/.kube/config** 
  * **sudo chown $(id -u):$(id -g) $HOME/.kube/config**
* At this point you'll have a one-node cluster that is ready to be further configured
* Use **kubectl cluster-info** to verify
* **kubectl get nodes** will give a not ready status, which is normal at this stage

```bash
kubeadm init
```
* Save the kubeadm join in a file
```bash
# example
#kubeadm join 192.168.100.210:6443 --token vgjjsj.2q171xk6qai16ebj \
# --discovery-token-ca-cert-hash sha256:41df972efc07eac3b5b578b249f985bb0dede475de5714dcdf0a7b5e79cd70ec 
vim kube-join.sh
```

```bash
# To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```bash
kubectl cluster-info
kubectl get nodes
```

### 3.3 Understanding Node Networking Requirements

#### Installing a Pod Network Add-on
* A network add-on must be installed for pods to communicate
* CNI is the Container Network Interface, which works with add-ons to implements networking
* Different projects exist for offering kubernetes network support, which requires support for the following types of networking:
  * container-to-container
  * pod-to-pod
  * pod-to-service
  * external-to-service
* Look for an add-on that supports _network-policy_ as well as RBAC (both covered later in this course)

#### Common Pod Networking Plugins
* Flannel: a layer 4 IPV4 network between cluster nodes that can be use several backend mechanisms such as VXLAN
* Weave: a common add-on for a CNI-enabled kubernetes cluster
* Calico: a layer 3 network solution that uses IP encapsulation and is used in kubernetes, OpenStac, OpenShift, Docker, and others
* AWS VPC: a network plugin that is common for AWS environments


* On the controller node
```bash
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n\')"
```

```bash
kubectl get pods --all-namespaces
```

```bash
# check the status. It is ready now
kubectl get nodes
```

* It is time to join the node workers to master, find the file join-net.sh recently created
* Note: if the token is expired, run **kubeadm token create** and you can see the token using **kubeadm token list** since it has a TTL.

```bash
# Use root credentials
ssh root@worker-1
ssh root@worker-2
ssh root@worker-3
# Copy the content from the file and copy to the terminal
```

### 3.4 Understanding kubectl Client Configuration
* Client configurationis built from the cluster /etc/kubernetes/admin.con and copied ~/.kube/config
* Different components are defined in the admin.conf
  * The default cluster to connect with
  * The default context
  * The user, which is just a set of PKI material used to connect to the cluster
* To work with multiple clusters, multiple contexts need to be defined in the client configuration
* Use **kubectl config** to manage client configuration context

```bash
# It is good idea use -h option for help
kubectl config -h 
```