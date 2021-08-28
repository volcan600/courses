# [Red Hat OpenShift Administration: Red Hat](https://learning.oreilly.com/videos/red-hat-openshift/9780137441938/)

Red Hat Openshift Container Platform: a platform that is managed by the customer to provide Openshift service on Physical or virtual infrastructure, on premise or in the cloud
Red Hat Openshift Dedicated: a Red Hat managed cluster offered in AWS, GCP, Azure, or IBM Cloud
Cloud-provider managed Openshift solutions
Red Hat Openshift Online: a Red Hat managed Openshift infrastructure that is shared across multiple customers
Red Hat Openshift Kubernetes Engine: just Kubernetes and related features
Red Hat Code Ready Containers: a minimal Openshift installation
OKD: the openshift opensource upstream



Managing Clusters with Web Console
oc whoami
oc whoami --show-console
oc get routes -n openshift-console

Understating Projects
- The Linux kernel provides namespaces to offer strict isolation between processes
- Kubernetes implements namespaces in a cluster environment

Monitoring Application
oc logs podname
oc describe
od get pod podname -o yaml
oc completion -h
source <(oc completion bash) # this will show all command using tab, very helpful
oc get pods --show-labels # helpful for filtering
oc get all --selector app=mymariadb # will show more information about error
oc describe pod mymariadb-58b96cb658-zbv94
oc logs mymariadb-58b96cb658-zbv94


Exploring the APIs
oc api-resources shows resources as defined in the API
oc api-versions shows versions of the APIs
oc explain [--recursive] can be used to explore what is in the APIs
oc explain pod.spec # gets information about spec section for specific resource
oc explain pod.spec.containers
oc explain pv.spec | less
Run dry mode and output to yaml
oc new-app bitname/nginx --dry-run=true -o yaml > mynewapp.yaml
Create yaml using kubectl run command 
kubectl run redis -image=redis -dry-run=client -o yaml > pod.yaml 
Generate deployments yaml 
kubectl create deployment --image=nginx nginx --dri-run=client -o yaml > nginx-deployment.yaml 
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml --replicas=4 > nginx-deployment.yaml 
Change namesapce manually 
kubectl config set-context $(kubectl config current-context) --namespace=dev 
Generate service yaml 
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml  
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml 
How to connect to crc vm machine
cd ~/.crc/machines/crc
ssh -i id_ecdsa core@$(crc ip)
Decoupling Storage with Persistent Volumes
dd if=/dev/zero of=loopbackfile bs=1M count=1000
losetup -fP loopbackfilp
ls -l /dev/loop0


Using StorageClass
Need to check again

## 4.5 Using ConfigMap
* ConfigMaps are used to decouple information
* Different types of information can be stored in ConfigMaps
  * Command line parameters
  * Variables
  * ConfigFiles

### Commands
Use --from-file to put the contents of a configuration file in the ConfigMap
```kubectl create cm myconf --from-file=my.conf```

Use --from-env-file to define variables
```kubectl create cm variables --from-env-file=variables```

Use --from-literal to define variables or command line arguments
```kubectl create cm special --from-literal=VAR3=cow --from-literal=VAR4=goat```

```kubectl describe cm <cmname>```

### Demo One
oc create cm variables --from-env-file=/variables

oc describe variables

### Demo Two
kubectl create cm special --from-literal=VAR3=cow --from-literal=VAR4=goat

oc get cm morevars

oc get cm morevars -o yaml

### Demo Three
oc create cm nginx-cm --from-file nginx-custom-config.conf

oc describe cm nginx-cm

cat nginx-cm.yaml

oc create -f nginx-cm.yaml

oc exec -it nginx cm -- /bin/bash

## 4.6 Using the Local Storage Operator
Install localstorage on OperatorHub

oc get all -n openshift-local-storage

Need to create storage device 
```
cd ~/.crc/machines/crc

ssh -i id_ecdsa core@$(crc ip)

sudo -i

cd /mnt/

dd if=/dev/zero of=loopbackfile bs=1M count=1000

losetup -fP loopbackfile

ls -l /dev/loop0
```

cat localstorage.yml

oc create -f localstorage.yml

oc get all -n openshift-local-storage

oc get sc

## 5.1 Authenticating as a Cluster Administrator

### Understating Users
* A user is an Openshift object who can be granted permissions in the system by adding roles to the user or usergroup, using rolebindings
* Openshift has three different type of users:
  * System users are automatically created to allow parts of Openshift to securely interact with the API.
  * Service accounts are special system user that are associated with projects to give additional privileges to Pod and deployments.
  * Regular users represent people who can perform specific tasks in Openshift

### Understating the Cluster Administrator
* After installing Opeshift, there are two ways to authenticate API requests with administrator privileges
  * The kubeadmin virtual user and password that grants an OAuth access token
  * The kubeconfig file that embeds an x.509 client certificate that doesn't expire

### Authenticating with the x.509 Certificate
* Authenticaing with the x.509 Certifacate
  * On Crc, you'll find it in \~/.crc.machines/crc
  * On real Cluster it is in \~/auth.kubeconfig
* Use **export KUBECONFIG=/home/student/.crc/machines/crc/kubeconfig** to use it
* Next, use any oc command you want
* Alternatively, use oc --config \~/.crc/machines/crc/kubeconfig get nodes (or any other command) to specify the config to use on the command line


### Authenticating with the Virtual User
* The kubeadmin virtual user is a hard-coded cluster administrator user
* Privileges of this user cannot be changed
* Also the password is dynamically generated and hard-coded
* The installating logs show how to log ing as this user
* After setting up an identity provider and creating a new user which has been assigned the cluster-admin role, the hard coded user can be removed
* Don't do this before verifying the new account works
  * **oc delete secret kubeadmin -n kube-system**

## 5.2 Uderstanding Identity Providers

### Understading Authentication and Authorization
* When accessing Openshift Cluster resources, a user makes a request to the API
* The authentication layer is responsible for authentication of the user
* Next, the authorization layer uses the RBAC policy to determine what user is authorized to do
* If API requests container invalid aithentication, it is authenticated as a request by the anonymous system user

### Openshift Authentication Methods
* OAuth Access Tokens uses access tokens to authenticate a request
* x.509 Client Certificates uses TLS certificates to authenticate requests

### Understanding the Authentication Operator
* The Openshift Authentication Operator runs an OAuth server
* This server provides access tokens to users that authenticate to the API
* The OAuth server works with an identity provider to validate the identity of requester
* This server connects the user with the identity and creates the OAuth access token which is next granted to the user

### Openshift Identity Providers
* HTPasswd: validates useranames and passwords against a Kubernetes secret that stores credentials generated by the **htpasswd** command
* Keystone: uses the OpenStach Keystone server for authentication
* LDAP: uses LDAP identity provider to verify authentication
* GitHub: uses the GitHub identity provider
* Open ID Connect: integrates with OpenID connect

## 5.3 Configuring the HTPasswd Identity Provider

### Understanding the HTPasswd Identity Provider
* The HTPasswd Identity Provider uses a Kubernetes secret that contains usernames and passwords generated with the Apache **htpasswd** command
* Using this identity provider us recommended for small proof of concept environments
* In large enviroments, integration with the organization identity management system is recommended

### Configuring the OAuth Custom Resource
* To use the HTPasswd Identity Provider, the OAuth Custom Resource must be configured
* This resource exists by default as kind: OAuth, and it should contain spec.identityProviders.htpasswd in the list of identity providers
* An example oauth.yaml file is provided in the course Git repository
* In this example file, the spec.identityProviders.htpasswd.fileData.name field refers to the secret that needs to exist and contains the htpasswd generated passwords
* **Tip!** Use **oc explain oauth.spec** for information on how to set it up

### Updating the OAuth Custom Resource
* To configure the OAuth HTPasswd Identity Provider, the OAuth custom resource must be updated
  * **oc get oauth cluster -o yaml > oauth.yaml**
* After applying the required changes, the new custom resource can be applied
  * **oc replace -f oauth.yaml**

## 5.4 Creating and Deleting Users

Use "-c" just one since if you re-use it will overwrite the first command or file

```bash
htpasswd -c -B -b  /tmp/htpasswd admin password
```

Add more users

```bash
htpasswd -b /tmp/htpasswd anna password
```

```bash
htpasswd -b /tmp/htpasswd linda password
```

```bash
cat /tmp/htpasswd
```

```bash
oc create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd -n openshift-config
```

```bash
oc describe secret htpasswd-secret -n openshift-config
```

```bash
oc adm policy add-cluster-role-to-user cluster-admin anna
```

```bash
oc get oauth
```

```bash
oc get oauth -o yaml > oauth.yaml
```

Modify the line identityProviders, name to httpasswd-secret

```yaml
identityProviders:
	- htpasswd:
		fileData:
			name: httpasswd-secret
```

```bash
oc replace -f oauth.yaml
```

```bash
oc get pods -n openshift-authentication
```

```bash
oc get users
```

```bash
oc login -u anna -p password
```

```bash
oc get users
```

```bash
oc get nodes
```

```bash
oc login -u linda -p password
```

```bash
oc get nodes
```

```bash
oc login -u anna -p password
```

You need to login with each user before see changes using **oc get users**

```bash
oc get users
```

```bash
oc get identity
```