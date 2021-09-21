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

```bash
# Check the nodes recently added in status "Ready"
kubectl get nodes
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

```bash
# It is the almost the same than check the file difectly "cat ./.kube/config". The first just ommit some data
# Important: the second command is to check using the local user
kubectl config view
cat ./.kube/config
```

```bash
# If any problem with the local user, you can always export the admin.conf to ~/.kube/config file
sudo cat /etc/kubernetes/admin.conf
```

### 4.1 Understanding the Kubernetes API
* Kubernetes has not one API, but a collection of APIs that define the objects and services that can be used in kubernetes
* API groups can be addressed to find out which version is available
* The APIs are RESTful, which means that information from the API can be obtained using commands like **curl**

#### Controlling API Access
* API access is regulated by using RBAC
* In RBAC, user accounts are idenfied as a set of certificates associated to a name, defined in ~/.kube/config
* Use **kubectl auth can-i** to verify what you can do with current credentials
  * **kubectl auth can-i create deployments**
  * **kubectl auth can-i create pods --as linda**
  * **kubectl auth can-i create pods --as linda --namespace apps**

### 4.2 Understanding Core Kubernetes Objects


### 4.3 Using option to Explore the API

#### Options for Accessing the API
* **kubectl api-resources** will show API groups and resources within the APIs
* After running **kubectl proxy**, you can also use curl to explore group information
  * **curl http://localhost:8001/apis**
* **kubectl api-versions** will show current API versions
* **kubectl explain** can be used to explore API components

### 4.4 Using kubectl to Manage API Objects

#### Using kubectl
* The **kubectl** command is the default command to interface the API
* Use **kubectl cluster-info** as first test of its working
* Current configuration is stored in \~/.kube.config
* Use **kubectl config view** to view the current config
* Multi-cluster access is possible, but a bit complicated, see https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-cluster for more details

#### Enabling Shell Autocompletion
* Depending on how you installed kubernetes, **kubectl** bash completion may not present by default
* Install the **bash-completion** package first
* Next, enable **kubectl completion bash** using **kubectl completion bash >/etc/bash_completion.d/kubectl** or **kubectl completion bash >> ./bashrc**

### 4.5 Using YAML Files to Define API Objects
* **kubectl create -f busybox.yaml** creates the pod
* **kubectl get pods** show all pods
* **kubectl explain pods.containers.spec** It is important, **kubectl explain <name>**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox2
  namespace: default
  labels:
    app: busybox
spec:
  containers:
  - name: busy
    image: busybox
    command:
      - sleep
      - "3600"
```

### 4.6 Using curl to Work with API Objects

#### Accessing APIs Using curl
* The APIs are RESTful, which means they responde to typical HTTP requests such as GET, POST and DELETE
* This makes it easy to interact with other systems
* If the appropriate certificates are used, the API can be addressed directly using **curl**
  **curl --cert myuser.pem --key myuser-key.pem --cacert /root/myca.pem https://controller:6443/api/v1**
* To make API access easy without using certificates, **kubectl proxy** can be used
  * **kubectl proxy --port=8001 &**

#### Demo: curl with API objects
```bash
kubectl proxy --port=8001 &
```

```bash
curl http://localhost:8001/version
```

```bash
curl http://localhost:8001/api/v1/namespaces/default/pods
``` 

```bash
# Deleting pod using API
# Use case example, interact with frontend and API
curl -X DELETE http://localhost:8001/api/v1/namespaces/default/pods/busybox2
```

### 4.7 Using Others Commands

#### Understanding etcdctl
* The **etcdctl** command can be used to interrogate and manage the etcd database
* Different versions of the comand exist: **etcdctl2** is to interact with v2 of the API, and **etcdctl** is version independent

#### Demo: Install and use etcdctl

```bash
sudo yum update && sudo yum provides */etcdctl
```

```bash
sudo yum install -y etcd
```

### Lesson 4 Lab: Using curl to Explore the API
* Use **curl** to explore which Pods are present in the kube-system namespace

```bash
kubectl proxy --port=8001 &
```

```bash
curl  http://localhost:8001/api/v1/namespaces/kube-system/pods
```