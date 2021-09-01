# [Red Hat OpenShift Administration: Red Hat](https://learning.oreilly.com/videos/red-hat-openshift/9780137441938/)

Red Hat Openshift Container Platform: a platform that is managed by the customer to provide Openshift service on Physical or virtual infrastructure, on premise or in the cloud

Red Hat Openshift Dedicated: a Red Hat managed cluster offered in AWS, GCP, Azure, or IBM Cloud

Cloud-provider managed Openshift solutions

Red Hat Openshift Online: a Red Hat managed Openshift infrastructure that is shared across multiple customers

Red Hat Openshift Kubernetes Engine: just Kubernetes and related features

Red Hat Code Ready Containers: a minimal Openshift installation

OKD: the openshift opensource upstream



# Managing Clusters with Web Console
oc whoami

oc whoami --show-console

oc get routes -n openshift-console

# Understating Projects
* The Linux kernel provides namespaces to offer strict isolation between processes
* Kubernetes implements namespaces in a cluster environment

# Monitoring Application
oc logs podname

oc describe

oc get pod podname -o yaml

oc completion -h

source <(oc completion bash) # this will show all command using tab, very helpful

oc get pods --show-labels # helpful for filtering

oc get all --selector app=mymariadb # will show more information about error

oc describe pod mymariadb-58b96cb658-zbv94

oc logs mymariadb-58b96cb658-zbv94


# Exploring the APIs
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

cd \~/.crc/machines/crc

ssh -i id_ecdsa core@$(crc ip)

Decoupling Storage with Persistent Volumes

dd if=/dev/zero of=loopbackfile bs=1M count=1000

losetup -fP loopbackfilp

ls -l /dev/loop0

# Using StorageClass

## 4.5 Using ConfigMap
* ConfigMaps are used to decouple information
* Different types of information can be stored in ConfigMaps
  * Command line parameters
  * Variables
  * ConfigFiles

#### Commands
Use --from-file to put the contents of a configuration file in the ConfigMap
```bash
kubectl create cm myconf --from-file=my.conf
```

Use --from-env-file to define variables
```bash
kubectl create cm variables --from-env-file=variables
```

Use --from-literal to define variables or command line arguments
```bash
kubectl create cm special --from-literal=VAR3=cow --from-literal=VAR4=goat
```

```bash
kubectl describe cm \<cmname\>
```

#### Demo One
oc create cm variables --from-env-file=/variables

oc describe variables

#### Demo Two
kubectl create cm special --from-literal=VAR3=cow --from-literal=VAR4=goat

oc get cm morevars

oc get cm morevars -o yaml

#### Demo Three
oc create cm nginx-cm --from-file nginx-custom-config.conf

oc describe cm nginx-cm

cat nginx-cm.yaml

oc create -f nginx-cm.yaml

oc exec -it nginx cm -- /bin/bash

## 4.6 Using the Local Storage Operator
Install localstorage on OperatorHub

oc get all -n openshift-local-storage

Need to create storage device 

```bash
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

#### Understating Users
* A user is an Openshift object who can be granted permissions in the system by adding roles to the user or usergroup, using rolebindings
* Openshift has three different type of users:
  * System users are automatically created to allow parts of Openshift to securely interact with the API.
  * Service accounts are special system user that are associated with projects to give additional privileges to Pod and deployments.
  * Regular users represent people who can perform specific tasks in Openshift

#### Understating the Cluster Administrator
* After installing Opeshift, there are two ways to authenticate API requests with administrator privileges
  * The kubeadmin virtual user and password that grants an OAuth access token
  * The kubeconfig file that embeds an x.509 client certificate that doesn't expire

#### Authenticating with the x.509 Certificate
* Authenticaing with the x.509 Certifacate
  * On Crc, you'll find it in \~/.crc.machines/crc
  * On real Cluster it is in \~/auth.kubeconfig
* Use **export KUBECONFIG=/home/student/.crc/machines/crc/kubeconfig** to use it
* Next, use any oc command you want
* Alternatively, use oc --config \~/.crc/machines/crc/kubeconfig get nodes (or any other command) to specify the config to use on the command line


#### Authenticating with the Virtual User
* The kubeadmin virtual user is a hard-coded cluster administrator user
* Privileges of this user cannot be changed
* Also the password is dynamically generated and hard-coded
* The installating logs show how to log ing as this user
* After setting up an identity provider and creating a new user which has been assigned the cluster-admin role, the hard coded user can be removed
* Don't do this before verifying the new account works
  * **oc delete secret kubeadmin -n kube-system**

## 5.2 Uderstanding Identity Providers

#### Understading Authentication and Authorization
* When accessing Openshift Cluster resources, a user makes a request to the API
* The authentication layer is responsible for authentication of the user
* Next, the authorization layer uses the RBAC policy to determine what user is authorized to do
* If API requests container invalid aithentication, it is authenticated as a request by the anonymous system user

#### Openshift Authentication Methods
* OAuth Access Tokens uses access tokens to authenticate a request
* x.509 Client Certificates uses TLS certificates to authenticate requests

#### Understanding the Authentication Operator
* The Openshift Authentication Operator runs an OAuth server
* This server provides access tokens to users that authenticate to the API
* The OAuth server works with an identity provider to validate the identity of requester
* This server connects the user with the identity and creates the OAuth access token which is next granted to the user

#### Openshift Identity Providers
* HTPasswd: validates useranames and passwords against a Kubernetes secret that stores credentials generated by the **htpasswd** command
* Keystone: uses the OpenStach Keystone server for authentication
* LDAP: uses LDAP identity provider to verify authentication
* GitHub: uses the GitHub identity provider
* Open ID Connect: integrates with OpenID connect

## 5.3 Configuring the HTPasswd Identity Provider

#### Understanding the HTPasswd Identity Provider
* The HTPasswd Identity Provider uses a Kubernetes secret that contains usernames and passwords generated with the Apache **htpasswd** command
* Using this identity provider us recommended for small proof of concept environments
* In large enviroments, integration with the organization identity management system is recommended

#### Configuring the OAuth Custom Resource
* To use the HTPasswd Identity Provider, the OAuth Custom Resource must be configured
* This resource exists by default as kind: OAuth, and it should contain spec.identityProviders.htpasswd in the list of identity providers
* An example oauth.yaml file is provided in the course Git repository
* In this example file, the spec.identityProviders.htpasswd.fileData.name field refers to the secret that needs to exist and contains the htpasswd generated passwords
* **Tip!** Use **oc explain oauth.spec** for information on how to set it up

#### Updating the OAuth Custom Resource
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

## 5.5 Managing Users


#### Managing Users
* Managing existing users is a three-step procedure
  * Use **oc extract** to extract the current username and passwoed from the secret and write it back to htpasswd
  * Update the current credentials using **htpasswd**
  * Use **oc set data secret** to write the updated data to the secret
* After updating the secret, the oAuth operator redeploys Pods in the openshift-authentication namespace

##### Demo: Changing a User Password

```bash
oc extract secret/htpasswd-secret -n openshift-config --to /tmp/ --confirm
```

```bash
htpasswd -B -b /tmp/htpasswd anna newpassword
```

```bash
htpasswd -B -b /tmp/htpasswd linda secret
```

```bash
htpasswd -B -b /tmp/htpasswd bob password
```

```bash
oc set data secret/htpasswd-secret --from-file htpasswd=/tmp/htpasswd -n openshift-config
```

#### Deleting Users
* The procedure to delete users is comparable to the procedure to update users
  * Extract the current secret data to a temporary file
  * Use **htpasswd** -D to delete the user
  * Use **oc set data secret** to update the secret

## 5.6 Managing User Group Membership

#### Working with Groups
* Groups use to assing additional privileges to people users
* Use oc adm groups to work with Groups
  * **oc adm groups new developers**
  * **oc adm groups add-users developers anna**
  * **oc get groups** will show currently existing groups
* After creating groups, use **oc policy** to grant privileges
  * **oc policy add-role-to-group edit developers**

## 5.7 Assigning Administrative Privileges
* To assign Administrative privileges, the user must be added to the cluster admin role:
  * **oc adm policy add-cluster-role-to-user cluster-admin anna**
* Tip: Use Tab completion to complete the oc adm policy command

#### Demo: 
```bash
oc adm policy -h
```

```bash
oc adm policy add-cluster-role-to-user cluster-admin linda
```

## Lesson 5 Lab Managing Users
* Use the HTPassword provider to create users lisa and lori. Both have the passwords set to "password". User Lisa should be granted 
administrator privileges and user lori should not.
```bash
oc extract secret/htpasswd-secret -n openshift-config --to /tmp --confirm
```

```bash
htpasswd -B -b /tmp/htpasswd lisa password
```

```bash
htpasswd -B -b /tmp/htpasswd lori password
```

```bash
oc set data secret/htpasswd-secret --from-file htpasswd=/tmp/htpasswd -n openshift-config
```

```bash
oc adm policy add-cluster-role-to-user cluster-admin lisa
```

```bash
oc login -u lisa -p password
```

```bash
oc get nodes
```

```bash
oc login -u lori -p password
```

```bash
oc get users
```

* After creating the users, log in as either of these users to verify that the administrator command **oc get nodes** works
* After trying this, use **oc get users** to verify the existence of both users

## 6.1 Managing Permissions with RBAC

##### Understanding RBAC
* The purpose of RBAC is to connect users to specific roles
* Roles have either a project or a cluster scope
* Different types of users are available
* Users are created as a specific user type, and are granted access to cluster resources using role bindings


##### Understanding Roles
* A _role_ is an API resource that gives specific _users_ access to OpenShift resources, based on _verbs_
  * Verbs are used as permissions, and include **get, list, watch, create, update, patch, delete**
* Cluster Roles are created when OpenShift is installed
* Local Roles provide access to project-based resources
* Use **oc describe clusterrole.rbac** for an overview of currently existing cluster roles

##### Understanding Role Bindings
* A _Role Binding_ is used to connect a cluster role to a user or group
* Use **oc describe clusterrolebinding.rbac** for an overview of bindings between users/groups and roles
* Use **oc describe rolebinding.rbac** to see all roles with a non-cluster scope
* Use **oc describe rolebinding.rbac -n myproject** to see local roles assigned to a specific project


##### Understanding Default Roles
* Some default roles are provided to be applied locally or to the entire cluster
  * admin: gives full controll to _all project_ resources
  * basic-user: gives read access to projects
  * cluster-admin: allows a user to perform any action in the _cluster_
  * cluster-status: allows a user to request status information
  * edit: allows creating and modifying commong applications resources, but gives no access to permissions, quotas, or limit ranges
  * self-provisioner: this cluster role allows users to create new projects
  * view: allows users to view but not modify project resources
* The **admin** role give full project permissions
* To **edit** role corresponds to the typical developer user

##### Understanding User Types
* Regular users represent a user object that is granted access to the cluster platform
* System users are created automatically to allow system components to access specific resources
  * system:admin has full admin access
  * system:openshift-registry is used for registry access
  * system:node:server1.example.com is used for node access
* Service accounts are special system accounts used to give extra privileges to pods or deployments
  * deployer: is used to create deployments
  * builder: is used to create build configs in S21

##### Managing RBAC
* Cluster administrators can use **oc adm policy** to manage cluster and namespace roles
  * **oc adm policy add-cluster-role-to-user rolename username**
  * **oc adm policy remove-cluster-role-from-user rolename username**
* To figure out who can do what, use **oc adm policy who-can delete user**

###### Demo:
```bash
oc get clusterrolebinding -o wide | grep 'self-provisioner'
```

```bash
oc describe clusterrolebinding self-provisioner

```

```bash
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
```

```bash
oc login -u linda -p secret
```

```bash
oc login -u admin -p password
```


```bash
oc new-project authorization-rbac
```

```bash
oc policy add-role-to-user admin linda
```

```bash
oc adm groups new dev-group
```

```bash
oc adm groups add-users dev-group anouk
```

```bash
oc adm groups new qa-group
```

```bash
oc adm groups add-users qa-group lisa
```

```bash
oc get groups
```

```bash
oc policy add-role-to-group edit dev-group
```

```bash
oc policy add-role-to-group view qa-group
```

```bash
oc get rolebinding -o wide
```

```bash
oc adm policy add-cluster-role-to-group --rolebinding-name self-provisioners self-provisioner system:authenticated:oauth
```

## 6.2 Managing Access Control

##### Creating Roles
* New roles can be created by assigning verbs and resources to the newly created role
* **oc create role podview --verb=get --resource=pod -n userstuff**
* **oc adm policy add-role-to-user podview ahmed --role-namespace=userstuff -n userstuff**
* **oc create clusterrole podviewonly --verb=get --resource=pod**
* **oc adm policy add-cluster-role-to-user podviewonly lori**

###### Demo
```bash
# Create the namespace as admin if it is not created
oc create role podview --verb=get --resource=pod -n userstuff
```

```bash
# Allow linda user to view pods in userstuff namespace
oc adm policy add-role-to-user podview linda --role-namespace=userstuff -n userstuff
```

```bash
# Create role to assigned to the entire cluster
oc create clusterrole podviewonly --verb=get --resource=pod
```

```bash
# Assign pod view for lori in the entire cluster
oc adm policy add-cluster-role-to-user podviewonly lori
```

## 6.3 Using Secrets to Manage Sensitive Information

##### Understanding Secrets
* A secret is a base64 encoded ConfigMap
* To really protect data in secret, the Etcd can be encrypted
* Secrets are commonly used to decouple configuration and data from the applications runing in OpenShift
* Using secrets allows OpenShift to load site-specific data from external sources
* Secrets can be used to store different kind of data
  * Passwords
  * Sensitive configuration files
  * Credentials such as SSH Keys or OAuth tokens

##### Understanding Secret Types
* Different types of secrets exist:
  * docker-registry
  * generic
  * tls
* When information is stored in a secret, OpenShift validates that the data conforms to the type of secret
* In OpenShift, secrets are mainly used for two reasons
  * To store credentials which is used by Pods in a MicroService architecture
  * To store TLS certificates and keys
  * A TLS secret stores the certificate as tls.crt and the certificate key as tls.key
  * Developers can mount the secret as a volume and create a pass-through route to the application

##### Creating Secrets
* Generic secrets: **oc create secret generic secretvars --from-literal user=root --from-literal password=verysecret**
* Generic secrets, containing SSH keys: **oc create secret generic ssh-keys --from-file id_rsa=\~/.ssh/id_rsa --from-file 
id_rsa.pub=\~/.ssh/id_rsa.pub**
* Secrets containing TLS certificate and key: **oc create secret tls secret-tls --cert certs/tls.crt kets/tls.key**

##### Exposing Secrets to Pods
* Secrets can be referred to as variables, or as files from the Pod
* Use **oc set env** to write the environment variables obtained from a secret to a pod or deployment
  * **oc set env deployment/mysql --from secret/mysql --prefix MYSQL_**
* Use  **oc set volume** to mount secrets as volumes
* Notice that when using **oc set volume**, all files currently in the target directory are not longer accesible.
  * **oc volume deployment/mysql --add --type secret --mount-path /run/secrets/mysql --secret-name mysql**
* Notice that **oc set env** can use **--prefix** to add a prefix to the environment variables defined in the secret

###### Demo

```bash
oc create secret generic mysql --from-literal user=sqluser --from-literal password=password --from-literal database=secretdb --from-literal hostaname=mysql --from-literal root_password=password
```

```bash
oc new-app --name mysql --docker-image bitnami/mysql
```

```bash
oc logs \<podname\>
```

```bash
# Read variables from secrets, all variables is under MYSQL_
oc set env deployment/mysql --from secret/mysql --prefix MYSQL_ 
```

```bash
# Verify environment options used with secret
oc exec -it \<podname\> -- env
```

## 6.4 Creating ServiceAccounts

##### Understating ServiceAccounts
* A ServiceAccount (SA) is a user account that is used by Pod to determine Pod access privileges to system resources
* The default ServiceAccount used by Pods allows for very limited access to cluster resources
* Sometimes a Pod cannot run with this very restricted ServiceAccount
* After creating the ServiceAccount, specific access privileges need to be set

##### Configuring ServiceAccount Access Restrictions
* To create a Service Account, use **oc create serviceaccount mysa**
* Optionally, add **-n namespace** to assign the SA to a specific namespace
* After creating the SA, use a role binding to connect the SA to a specific Security Context Constraint (see lesson 6.5)

###### Demo

```bash
# Look up "serviceAccount: and serviceAccountName:"
oc get pod mypod -o yaml
```

```bash
oc create sa newsa 
```

```bash
oc get sa
```

## 6.5 Managing Security Context Constraints

##### Understanding Security Context Constraints
* A Security Context Constraint (SCC) is an OpenShift resource, similar to the Kubernetes Security Context resources, that restricts access to resources
* The purpose is to limit access from a Pod to the host environment
* Different SCCs are available to control:
  * Running privileged containers
  * Requesting additional capabilities to a container
  * Using hosts directories as volumes
  * Changing SELinux context of a container
  * Changing the user ID
* Using SCCs may be necessary to run community containers that by default don't work under the tight OpenShift security restrictions

##### Exploring SCCs
* Use **oc get ssc** for an overview of SCCs
* For more details, use **oc describe scc \<name\>**, as in **oc describe scc nonroot**
* Use **oc describe pod \<podname\> | grep scc** to see which SCC is currently used by Pod
* If a Pod can't run due to an SCC use **oc get pod \<name\> -o yaml | oc adm policy scc-subject-review -f -**
* To change a container ro run with a different SCC, you must create a service account and use that in the Pod



###### Demo One

```bash
oc new-project scctest
```

```bash
oc get scc
```

```bash
oc describe scc nonroot
```

```bash
# It will failed since it requires root privileges
oc run nginx --image=nginx
```

```bash
oc get pod nginx -o yaml | oc adm policy scc-subject-review -f -
```

##### Using SCCs
* **oc get scc** gives an overview of all SCCs
* **oc describe scc anyuid** shows information about a specific SCC
* **oc describe pod** shows a line openshift.oi/scc: restricted; most Pods runs as restricted
* Some Pods require access beyond the scope of their own containers, such as S21 Pods. To provide this access, SAs are needed
* To change the container to run using a different SCC, you need to create a service account and used that with Pod or Deployment

##### Understanding SCC and ServiceAccount
* The service account is used to connect to an SCC
* Once the service account is connected to the SCC it can be bound to a deployment or pod to make sure that it is working
* This allows you for instance to run a Pod that requires root access to use the anyuid SCC so that it can run anyway

###### Demo Two, Using SCCs
* As linda user: **oc new-project sccs**
* **oc new-app --name sccnginx --docker-image nginx**
* **oc get pods** will show an error
* **oc logs pod/nginx\[Tab\]** will show that is fails beacause of a permission problem
* as admin user: **oc get pod sccnginx\[Tab\] -o yaml | oc adm policy scc-subject-review -f -** will show which scc to use
* as admin user: **oc create sa nginx-sa** creates the dedicated service account
* As administrator: **oc adm policy add-scc-to-user anyuid -z nginx-sa**
* As linda: **oc set serviceaccount deployment sccnginx nginx-sa**
* **oc get pods sccs\[Tab\] -o yaml**; look for a service account
* **oc get pods** should show the pod as running(may have to wait a minute)

## 6.6 Running Container as Non-root
* By default, OpenShift denies containers to run as root
* Many containers run as root by default
* A container that runs as root has root privileges on the container hosts as well, and should be avoided
* If you build your own container images, specify which user it should run
* Frequently, non-root alternatives are available for the images you're using
  * quay.oi images are made with OpenShift in mind
  * bitnami has reworked common images to be started as non-root

##### Managing Non-root Container Ports
* Non-root containers cannot bind to a privileged port
* In OpenShift, this is not an issue, as containers are accessed through services an routes
* Configure the port on the service/route, not on the Pod
* Also, non-root containers will have limitations accessing files

##### Demo: Runing Bitnami non-root Nginx

```bash
oc new-app --docker-image=bitnami/nginx:latest --name=bginx
```

```bash
oc get pods -o wide
```

```bash
oc describe pods bginx
```

```bash
oc get services
```

## Lesson 6 Lab: Fixing Application Permissions
* Use **oc run mynginx --image=nginx** to run an Nginx webserver Pod
* It fails. Fix it

```bash
oc run mynginx --image=nginx
```

```bash
oc logs mynginx
```

```bash
oc get pod mynginx -o yaml | oc adm policy scc-subject-review -f -
```

```bash
oc create serviceaccount mynginx-sa
oc get sa
```

```bash
oc adm policy add-scc-to-user anyuid -z mynginx-sa
```

```bash
oc login -u linda -p password
oc get pods mynginx -o yaml > mynginx.yaml
oc delete pod mynginx
```

```bash
# Modify the both values with the mynginx-sa, serviceAccount:, serviceAccountName:
oc create -f mynginx-sa
```

## 7.1 Understanding OpenShift Resources

##### Understanding OpenShift Networking
* Services provide load balancing to replicated Pods in an application, and are essential in providing access to applications
  * Services connect to Endpoints, which are Pod individual IP addresses
* Ingress is a kubernetes resources that exposes services to external users
  * Ingress adds URLs, load balancing, as well as access rules
  * Ingress is not used as such in OpenShift
* OpenShift routes are an alternative to Ingress

## 7.2 Understanding OpenShift SDN

##### Understanding OpenShift SDN
* OpenShift uses Software Defined Networking (SDN) to implement connectivity
* OpenShift SDN separates the network in a control plane and data plane
* The SDN solves five requirements
  * Manage network traffic and resources as software such that they can be programmed by the application owners
  * Communicate between containers running within the same project
  * Communicate between Pods within and beyond project boundaries
  * Manage network communication from a Pod to a service
  * Manage network communication from external network to service
* The network is managed by the OpenShift Cluster Network Operator

##### Understanding the DNS Operator
* To DNS operator implements the CoreDNS DNS server
* The internal CoreDNS server is used by Pods for DNS resolution
* Use **oc describe dns.operator/default** to see its config
* The DNS Operator has different roles
  * Create a default cluster DNS name cluster.local
  * Assign DNS names to namespaces
  * Assign DNS names to services
  * Assign DNS names to Pods

##### Managing DNS Records for Services
* DNS names are composed as servicename.projectname.cluster-dns-name
  * **db.myproject.cluster.local**
* Apart from the A resource records, core DNS also implements an SRV record, in which port name and protocol are prepended to the service A record name
  * **\_443.tcp\_.webserver.myproject.cluster.local**
* If a service has no IP address, DNS records are created for the IP address of the Pods, and roundrobin is applied

##### Understanding the Cluster Network Operator
* The OpenShift Cluster Network Operator defines how the network is shaped and provides information about the following:
  * Network address
  * Network mode
  * Network provider
  * IP address pools
* Use **oc get network/cluster -o yaml** for details
* Notice that currently OpenShift only supports the OpenShift SDN network provider, this may have changed by time your read this
* Future versions will use OVN-kubernetes to manage the cluster network

##### Understanding Network Policy
* Network policy allows defining Ingress and Egress filtering
* If no network policy exists, all traffic is allowed
* If a network policy exists, it will block all traffic with the exception of allowed Ingress and Engress traffic

## 7.3 Managing Services

##### Using Service for Accessing Pods
* A service is used as a load balancer that provides access to a group of Pods that is addressed by using a label as the selector
* Services are needed for Pod access as Pods are dynamically addedas well as removed
* Services using labels and selectors to dynamically address Pods
* When using **oc new-app**, a service resource is automatically added to expose access to the application

##### Understanding Service Types
* ClusterIP: the service is exposed as an IP address internal to the cluster. This is used as the default type, where services cannot be directly addressed
* NodePort: a service type that exposes a port on the node IP address.
* LoadBalancer: exposes the service through a cloud provider load balancer. The cloud provider LB talks to the OpenShift network controller to automaticalycreate a node port to route incoming requests
* ExternalName: creates CNAME in DNS to match an external hostname. Use this to create different access points for applications external to the cluster

## 7.4 Managing Routes


##### Understanding the Ingress Resource
* Ingress traffic is generic terminoloy incoming traffic (and is more than just kubenertes Ingress)
* The ingress resources is managed by the ingress operator and accepts external requests that will be proxied
* The route resource is an OpenShift resource that provides more features than Ingress
  * TLS re-encryption
  * TLS passthrough
  * Split traffic for blue-green deployments


##### Understanding OpenShift Route
* OpenShift route resources are implemented by the shared router service that runs as a Pod in the Cluster
* Router Pods bind to public-facing IP addresses on the nodes
* DNS wildcard is required for this to work
* Routes can be implemented as secure and as insecure routes

##### Creating Routes Requirements
* Routes resources need the following values
  * Name of the service that the route accesses
  * A host name for the route that is related to the cluster DNS wildcard domain
  * An optional path for path-based routes
  * A target port, which is where the application listens
  * An encryption strategy
  * Optional labels that can be used as selectors
* Notice that the route does not use the service directly, it just needs it to find out to which Pods it should connect

##### Understanding Route Options and Types
* Secure routes can use different types of TLS termination
  * Edge: Certicates are terminated at the route, so TLS certificates must be configured in the route
  * Pass-through: termination is happening at the Pods, which means that the Pods are responsible for serving the certificates. Use this to support mutual authentication
  * Re-encryption: TLS traffic is terminated at the route, and new encrypted traffic is established with Pods
* Unsecure routes require no key or certificates

##### Create Insegure Routes
* Easy: just **oc expose service my.service --hostanme my.name.example.com**
  * The service my.service is exposed
  * The hostname my.name.example.com is set for the route
* If no name is specified, the name routename.projectname.defaultdomain is used
* Notice the only the OpenShift route, and not the coreDNS DNS server knows about route names
  * DNS has a wildcard domain name that sends traffic to the IP address that runs the router software, which will further tale care of the spefic name resolving
  * Therefore, the route name must alwats be a subdomain of the cluster wildcard domain

###### Demo

```bash
oc new-app --docker-image=bitnami/nginx --name bitginx
```

```bash
oc expose service bitginx
```

```bash
oc describe routes bitginx
```

## 7.5 Understanding DNS Name Resolving

##### Understanding OpenShift DNS
* Services are the first level of exposing applications
* To make service accessible, routes provide DNS names
* OpenShift has an internal DNS server, which is reachable from the cluster only
* To make OpenShift services accessible by name on the outside, Wildcard DNS is needed on the external DNS
* Wildcard DNS resolves to all resouces created within a domain
* External DNS has wildcard DNS to the OpenSHift Loadbalancer
* The OpenShift loadbalancer provides a front end to the control nodes
* The control nodes run the ingress controller and are a part of the cluster
* So they have access to the internal resource records

## 7.6 Creating Self-signed Certificate


##### Demo: Creating self-signed certificates
* Creating the CA
  * **mkdir \~/openssl**
  * **openssl genrsa -des3 -out myCA.key 2048**
  * **openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem**
* Creating the certificate
  * **openssl genrsa -out tls.key 2048**
  * **openssl req -new -key tls.key -out tls.csr** \# make sure the CN matches the DNS name of the route which is project.apps-crc.testing
* Self-signing the certificate
  * **openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256**

```bash
# Always fill the common name
mkdir ~/openssl
openssl genrsa -des3 -out myCA.key 2048
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem
openssl genrsa -out tls.key 2048
openssl req -new -key tls.key -out tls.csr
openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256
```

## 7.7 Securing Edge and Re-encrypt Routes Using TLS Certificates

##### Demo: Configuring an Edge Route - Part 1
* Part 1: Creating deploy, svc, route
  * **oc new-project myproject**
  * **oc create cm linginx1 --from-file linginx1.conf**
  * as admin: **oc create sa linginx-sa** creates the dedicated service account
  * as administrator: **oc amd policy add-scc-to-user anyuid -z linginx-sa**
  * **oc create -f linginx-v1.yaml**
  * **oc get pods**
  * **oc get svc**
  * **oc create route edge linginx1 --service linginx1 --cert=openssl/tls.crt -- key=openssl/tls.key --ca-cert=openssl/myCA.crt**
* Part 2: Testing from another pod in the cluster
  * curl -svv https://linginx-myproject.apps-crc.testing \# will show a self-signed certificate error
  * curl -s -k https://linginx-myproject.apps-crc.testing \# will give access

```bash
oc create cm linginx1 --from-file linginx1.conf
```

```bash
oc describe cm
```

```bash
oc create sa linginx-sa
oc login -u admin -p password
oc adm policy add-scc-to-user anyuid -z linginx-sa
```

```bash
oc create -f linginx-v1.yaml
```

```bash
oc create route edge linginx1 --service linginx1 --cert=../../../openssl/tls.crt --key=../../../openssl/tls.key --ca-cert=../../../openssl/myCA.pem --hostname=linginx-myproject.apps-crc.testing
```

```bash
oc get routes
```

```bash
curl -svv https://linginx-myproject.apps-crc.testing 
```

```bash
curl -s -k https://linginx-myproject.apps-crc.testing
```

## 7.8 Securing Passthrough Routes Using TLS Certificates

###### Demo: Configuring a Passthrough Route
* Part 1: Creating Certificates: ensure that subject name matches name used in the route
  * **mkdir openssl; cd openssl**
  * **openssl genrsa -des3 -out myCA.key 2048**
  * **openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem**
  * **openssl genrsa -out tls.key 2048 \# set common name to linginx-default.apps-crc.testing**
  * **openssl req -new -key tls.key -out tls.csr**
  * **openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256**
* Part 2: Creating Secret
  * **oc create secret tls linginx-certs --certs --cert tls.crt --key tls.key**
  * **oc get secret linginx-certs -o yaml**
* Part 3: Create a ConfigMap
  * **oc create cm nginxconfigmap --from-file default.conf**
  * **oc create sa linginx-sa** \# creates the dedicated service account
  * **oc adm policy add-scc-to-user anyuid -z linginx-sa**
* Part 4: Starting Deployment and Service
  * **vim linginx-v2.yaml** \# check volumes
  * **oc create -f linginx-v2.yaml**
* Part 5: Creating the Passthrough Route
  * **oc create route passthrough linginx --service linginx2 --port 8443 --hostname=linginx-default.apps-crc.testing**
  * **oc get routes**
  * **oc get svc**
* Part 6: Testing in a Debug Pod
  * **oc debug -t deployment/linginx2 --image registry.access.redhat.com/ubi8/ubi:8.0**
    * **curl -s -k https://172.25.201.41:8443**
  * **curl https://linginx-default.apps-crc.testing**
  * **curl --insecure https://linginx-default.apps-crc.testing**

```bash
openssl genrsa -des3 -out myCA.key 2048
```

```bash
# require to fill common name
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem
```

```bash
openssl genrsa -out tls.key 2048
```

```bash
# This common names should be the same than the application on oc create route "linginx-myproject.apps-crc.testing"
openssl req -new -key tls.key -out tls.csr
```

```bash
openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256
```

```bash
oc create secret tls linginx-certs --cert tls.crt --key tls.key
```

```bash
oc get secret linginx-certs -o yaml
```

```bash
cd ~/repo/courses/openshift
```

```bash
oc create cm nginxconfigmap --from-file default.conf
```

```bash
oc create sa linginx-sa
```

```bash
oc login -u admin -p password
oc adm policy add-scc-to-user anyuid -z linginx-sa
```

```bash
oc create -f linginx-v2.yaml
oc get pods
```

```bash
oc create route passthrough linginx --service linginx2 --port 8443 --hostname=linginx-myproject.apps-crc.testing
```

```bash
oc get routes
oc get svc
```

```bash
# it will enter inside of linginx
oc debug -t deployment/linginx2 --image registry.access.redhat.com/ubi8/ubi:8.0
```

```bash
sh-4.4# curl -s -k https://10.217.4.26:8443
```

```bash
curl https://linginx-myproject.apps-crc.testing
```

```bash
curl --insecure https://linginx-myproject.apps-crc.testing
```

## 7.9 Configuring Network Policies

##### Understanding Network Policies
* By default, there are no restrictions to network traffic on K8s
* Pods can always communicate, even if they're in other namespaces
* To limit this, Network Policies can be used
* If in a policy there is not match, traffic will be denied
* If no Network Policy is used, all traffic is allowed

##### Network Policy Identifiers
* In network policies, three different identifiers ca be used
  * Pods: (podSelector) note that a Pod cannot block access to itself
  * Namespaces: (namespaceSelector) to grant access to specific namespaces
  * IP blocks: (ipBlock) notice that traffic to and from the node where a Pod is running is always allowed
* When defining a Pod or namespace-based network policy, a selector label is used to specify what traffic is allowed to and from the Pods that match the selector
* Network policies do not conflict, they are additive

##### Allowing Ingress and Monitoring
* If cluster monitoring or exposed routes are used, Ingress from them needs to be included  in the network policy
* Use **spec.ingress.from.namespaceSelector.matchlabels** to define:
  * **network.openshift.io/policy-group:monitoring**
  * **network.openshift.io/policy-group:ingress**

###### Demo: Configuring Network Policy
* **oc login -u admin -p password**
* **oc apply -f nwpolicy-complete-example.yaml**
* **oc expose pod nginx --port=80**
* **oc exec -it busybox --wget --spider --timeout=1 nginx** will fail
* **oc label pod busybox access=true**
* **oc exec -it busybox --wget --spider --timeout=1 nginx** will work

```bash
oc login -u admin -p password
```

```bash
oc apply -f nwpolicy-complete-example.yaml
```

```bash
oc expose pod nginx --port 80
```

```bash
oc exec -it busybox --  wget --spider --timeout=1 nginx
```

```bash
oc label pod busybox access=true
```

```bash
oc exec -it busybox --  wget --spider --timeout=1 nginx
```

###### Demo: Advanced Network Policies
* **oc login -u kubeadmin -p ...**
* **oc new-project source-project**
* **oc label ns source-project type=incoming**
* **oc create -f nginx-source1.yaml**
* **oc create -f nginx-source2.yaml**
* **oc project targe-project**
* **oc new-app --name nginx-target --docker-image quay.io/openshifttest/hello-openshift:openshift**
* **oc get pods -o wide**
* **oc login -u kubeadmin -p ...**
* **oc exec -it nginx-access -n source-project -- curl \<ip-of-nginx-target-pod\>:8080**
* **oc exec -it nginx-noaccess -n source-project -- curl \<ip-of-nginx-target-pod\>:8080**
* **oc create -f nwpol-allow-specific.yaml**
* **oc exec -it nginx-noaccess -n source-project -- curl \<ip-of-nginx-target-pod\>:8080**
* **oc label pod nginx-target-1-<xxxx> type=incoming**
* **oc exec -it nginx-noaccess -n source-project -- curl \<ip-of-nginx-target-pod\>:8080**

```bash
oc new-project source-project
```

```bash
oc label ns source-project type=incoming
```

```bash
oc create -f nginx-source1.yml
oc create -f nginx-source1.yml
```

```bash
oc login -u linda -p password
oc new-project target-project
```

```bash
oc new-app --name nginx-target --docker-image quay.io/openshifttest/hello-openshift:openshift
oc get pods -o wide
```

```bash
# Should display "Hello Openshift!"
oc login -u admin -p password
oc exec -it nginx-access -n source-project -- curl 10.217.0.80:8080
```

```bash
# Should display "Hello Openshift!" for both since there is not network policies
oc exec -it nginx-access -n source-project -- curl 10.217.0.80:8080
oc exec -it nginx-noaccess -n source-project -- curl 10.217.0.80:8080
```

```bash
oc get pods -n source-project --show-labels
```

```bash
oc create -f nwpol-allow-specific.yaml
```

```bash
oc get pods --show-labels
```

```bash
oc label pod nginx-target-5b89446fb-h744q type=incoming
```

```bash
# Now should only access to nginx-access pod
oc exec -it nginx-access -n source-project -- curl 10.217.0.80:8080
oc exec -it nginx-noaccess -n source-project -- curl 10.217.0.80:8080
```

## 7.10 Troubleshooting OpenShift Networking

```bash
oc login -u linda -p password
```

```bash
oc new-project debug
```

```bash
# It is important to create a deployment, you can attach new pod to the deployment
oc create deployment dnginx --image=nginx
```

```bash
# There is an error
oc get all
```

```bash
oc debug deploy/dnginx --as-user=10000
```

```bash
oc debug deploy/dnginx --as-user=10000630001
```

```bash
# inside of the pod run
nginx
```

```bash
oc debug deploy/dnginx --as-root
```
* Do the same process with the admin user

## Lesson 7 Lab

```bash
# the common name is important, should be the same as the hostname for the secret
mkdir ~/openssl
openssl genrsa -des3 -out myCA.key 2048
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem
openssl genrsa -out tls.key 2048
openssl req -new -key tls.key -out tls.csr
openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256
```

```bash
oc new-project lab7
```

```bash
oc new-app --name nginxlab --docker-image=bitnami/nginx
```

```bash
oc create route edge nginxlab --service nginxlab --cert=openssl/tls.crt --key=openssl/tls.key --ca-cert=openssl/myCA.pem
```

```bash
oc get routes
```

```language
curl -s -k https://nginxlab-lab7.apps-crc.testing
```

## 8.1 Controlling Pod Placement
* 3 type of rules for Pod scheduling
  * Node labels
  * Affinity rules
  * Anti-affinity rules
* A label is an arbitrary key-value pair that is set with **oc label**
* Pods can next be configured with **nodeSelector** property on the Pod so that they'll only run on the node that has the right label
* Use **oc label node worker1.example.com env=test** to set the label
* Use **oc label node worker1.example.com env=prod --overwrite** to overwrite
* Use **oc label node worker1.example.com env-** to remove the label
* Use **oc get... --show-label** to show labels set on any type of resource
* To see which nodes are in which machine set, use **oc get machines -n openshift-machine-api -o wide**
* Use **oc edit machineset ...**  to set a label in the machine set spec.metadata
* If a Deployment is configured with a nodeSelector that doesn't match any node label, the Pods will show as pending
* **oc adm new-project test --node-selector "env=test"**
* To configure default nodeSelector **oc annotate namespace test openshift.io/node-selector="test" --overwrite**

###### Demo: Using NodeSelector
* **oc login -u linda -p password**
* **oc create deployment simple --image=bitnami/nginx:latest**
* **oc get all**
* **oc scale --replicas 4 deployment/simple**
* **oc get pods -o wide**
* **oc login -u admin -p password**
* **oc edit deployment/simple** 
```yaml
dnsPolicy: ClusterFirst
nodeSelector:
  env: blah
```
* **oc get nodes -L env**
* **oc label node xxxx env=dev**

## 8.2 Manually Scaling Pods
* Deployment is the kubernetes resource, DeploymentConfig is the OpenShift resource
* Deployment is the standard, but when using **oc new-app --as-deployment-config** it will create a DeploymentConfig instead
* **oc scale** to manually scale the number of Pods
  **oc scale --replicas 3 deployment myapp**
* Another way **oc edit deployment simple**

## 8.3 Automatically Scaling Pods
* OpenShift provides the **HorizontalPodAutoscaler** resource for automatically scaling Pods
* Base on requests or project resource limitations to take care of this

###### Demo

```bash
oc login -u admin -p password
```

```bash
oc new-project auto
```

```bash
oc new-app --name auto php~https://github.com/sandervanvugt/simpleapp
```

```bash
oc get deployment
oc get pods
```

```bash
oc autoscale deploy auto --min 5 --max 10 --cpu-percent 20
```

```bash
oc get hpa
```

```bash 
oc get deploy
```

```bash
oc get hpa -o yaml
```

```bash
oc explain hpa.spec
```

## 8.4 Applying Pod Resource Limitations
* Use **oc set resources** to set resource requests as well as limits, or edit the YAML code directly
* **oc set resources deployment hello-world-nginx --requests cpu=10m,memory=10Mi --limits cpu=50m,memory=50Mi**
* Exam tip! Use **oc set resources -h** for ready-to-use examples

```bash
oc new-project limits
```

```bash
oc create deployment nee --image=bitnami/nginx --replicas=3
```

```bash
oc get all
```

```bash
oc set resources deployment nee --requests cpu=10m,memory=1Mi --limits cpu=20m,memory=5Mi
```

```bash
oc get pods
oc get deploys
```

```bash
oc describe pod podname
```

```bash
oc set resources deploy nee --requests cpu=0m,memory=0Mi --limits cpu=0,memory=0
```

```bash
oc describe pod podname
```

##### Monitoring Resource Availability
* Use **oc describe node nodename** to get information about current CPU and memory usage for each Pod running on the node
* **oc adm top**
  * Notice this requires metrics server to be installed and configured. It won't by default

## 8.5 Applying Quotas
* Quotas are useful for preventing the exhaustion
* **resourcequotas** are applied to projects to limit use of resources
* **clusterresourcequotas** apply quota with a cluster scope
* Avoid using quota YAML

##### Verifying Resource Quota
* **oc get resourcequota** gives an overview of all resourcequota API resources
* **oc describe quota** will show cumulative quotas from all resourcequota in the current project


###### Demo

```bash
oc login -u admin -p password
```

```bash
oc new-project quota-test 
```

```bash
oc create quota qtest --hard pods=3,cpu=100,memory=500Mi
```

```bash
oc get quota
```

```bash
oc login -u linda -p password
```

```bash
oc create deploy bitginx --image=bitnami/nginx --replicas=4
```

```bash
oc get all
```

```bash
oc get rs bitginx
```

```bash
oc set resources deplyoy bitginx --requests cpu=10m,memory=50Mi --limits cpu=50m,memory=20Mi
```

```bash
oc get all
```

```bash
oc describe deployment bitginx
```

```bash
oc rs bitginx-restpodname
```

## 8.6 Applying Limit Range

```bash
oc new-project limits
```

```bash
oc explain limitrange.spec.limits
```

```bash
oc create -f limits.yaml
```

```bash
oc get limitrange 
```

```bash
oc describe limitranges limit-limits
```

```bash
oc delete -f limits.yaml
```

## 8.7 Speciying Quota Range
* This will set a cluster resource quota that applies to all projects owned by user lisa
  * **oc create clusterquota user-lisa --project-annotation-selector openshift.io/requester=lisa --hard pods=10,secrets=10**
* This will add a quota for all projects that have the label env=testing
  * **oc create clusterquota testing --projec-label-selector env=testing --hard pods=5,services=2**
  * **oc new-project test-project**
  * **oc label ns new-project env=testing**
* Project users can use **oc describe quota** to view quota that currently apply 
* **Tip!** Set quota on individual projects and try to avoid cluster-wide quota, looking them up in large clusters may take a lot of time!

###### Demo

```bash
oc create clusterquota testing --project-label-selector env=testing --hard pods=5,services=2
```

```bash
oc get clusterquota
```

```bash
oc get clusterquota  -A
```

```bash
oc new-project test-project
```

```bash
oc label ns test-project env=testing
```

```bash
oc describe quota
```

```bash
oc describe ns test-project
```

```bash
oc create deploy nginxmany --image=bitnami/nginx --replicas=6
```

```bash
oc describe deploy nginxmany
```

```bash
oc describe rs nginxmany-podname
```

```bash
oc delete clusterquota test-project
```

## 8.8 Modifying the Default Template

```bash
oc login -u admin -p password
```

```bash
oc adm create-bootstrap-project-template -o yaml > mytemplate.yaml
```

```bash
vim limitrange.yaml
```

```bash
oc create -f limitrange.yaml -n openshift-config
```

```bash
oc get template -n openshift-config
```

```bash
oc edit projects.config.openshift.io/cluster
#add the following
```

```yaml
spec:
  projectRequestTemplate:
    name: project-request
```

```bash
# wait some minutes
watch oc get pods -n openshift-apiserver
```

```bash
oc new-project template-project
```

```bash
oc get resourcequotas
```

```bash
oc get limitranges
```

## 8.9 Using Pod Affinity and Anti-affinity Rules
* [Anti-]affinity defines relations between Pods
* podAnffinity is a Pod property that tells the scheduler to locate a new Pod on the same node as other Pods

###### Demo: Using nodeAffinity

```bash
cat anti-affinity.yaml
```

```bash
oc new-project love
```


```bash
oc create -f anti-affinity.yaml
```

```bash 
oc get pods
```

```bash
oc describe anti2
```

###### Demo: Using nodeAffinity

```bash
oc login -u admin -p password
```

```bash 
cat node-affinity.yaml
```

```bash
oc create -f node-affinity.yaml
```

```bash
oc get pods
```

```bash
oc describe pod runonssd
```

```bash
# It is a node, oc get nodes to get the name
oc label node crc-ctj2r-master-0 distype=nvme
```

```bash
oc get pods
```

## 8.10 Managing Taints and Tolerations
* A taint allows a node to refuse a Pod unless the Pod has a matching toleration
* **taints** are applied to nodes through the node spec
* **tolerations** are applied to a Pod through the Pod spec
* The effect is one of the following:
  * NoSchedule: new Pods will not be scheduled
  * PreferNoSchedule: the scheduler tries to avoid scheduling new Pods
  * No Execute: new Pods won't be scheduled and existing Pods will be removed

###### Demo: Managing Taints (Fails on CRC)
* **oc login -u admin -p password**
* **oc adm taint nodes crc-[tab] key1=value1:NoSchedule**
* **oc run newpod --image=bitnami/nginx**
* **oc get pods**
* **oc describe pods mypod**
* **oc edit pod mypod**
```yaml
spec:
  tolerations:
  - key: key1
    value: value1
    operator: Equal
    effect: NoExecute
```
* **oc adm taint nodes crc-[Tab] key1-**

```bash
oc login -u admin -p password
```

```bash
# Use oc get nodes to get the node's name
oc adm taint nodes crc-5br8f-master-0 key1=value1:NoSchedule*
```

```bash
oc run newpod --image=bitnami/nginx
```

```bash
oc describe pod newpod
```

```bash
oc edit pod newpod
```

```yaml
spec:
  tolerations:
  - key: key1
    value: value1
    operator: Equal
    effect: NoExecute
```

```bash
oc get pods
```

## Lesson 8 Lab: Using Quota

```bash
oc new-project limit-project
```

```bash
oc create quota qtest --hard  pods-4,memory=1Gi
```

```bash
oc describe project limit-project
```

## 9.1 Monitoring Cluster Health

* **oc get nodes** is a good first step to investigate current health of nodes
* **oc adm top nodes** shows current node healt, based on statistics gathered by the metrics server
* **oc describe node** may be used to investigate recent events and resource usage
  * **Events** shows an event log
  * **Allocated resources** gives an overview of allocated resources and requests
  * **Capacity** shows available capacity
  * **Non-terminated Pods** shows Pods currently being used

##### Monitoring Operators
* **oc get clusteroperators** shows current status of operators
  * If an operator is in progressingsate, it is currently being updated
  * If in degraded state, something is wring and further investigation is required


##### Analyzing Operators
* **ClusterOperator** resources are non-namespaced
* Each operator starts its resources in dedicated namespaces
  * Some operators use one namespace, some operators use more
* If an operator shows a degraded status in **oc get co**, investigate resources running in its namspace and use common tools to check their status

```bash
oc get co
```

```bash
oc get ns | grep monitor
```

```bash
oc get all -n openshift-monitoring
```

##### Verifying Cluster Version
* **oc get clusterversion** shows details about the current version of the cluster that is used
* **oc describe clusterversion** shows more details about versions of the different components
* **oc version** shows OpenShift version, kubernetes version, as well as client version

## 9.2 Investigating Node Logs
* **oc adm node-logs nodename** will show logs generated by a CoreOS node
* **oc adm node-logs -u crio nodename** will show logs generated by the CRI-o service
* **oc adm node-logs -u kubelet nodename** will show logs generated by the kubelet service

##### Opening a Shell on Node
* Use **oc debug node/nodename** to open a debug shell on a node
  * The debug shell mounts the node root file system at the /host folder, which allows you to inspect files from the node
  * To run host binaries, use **chroot /host**
  * Notice that the host is running a minimal operating system and does not provide access to all Linux tolls
  * Use **systemctl status kubelet** or **systemctl status crio** to investigate status of these vital services
  * Use **crictl ps** for low-level information about CRI-o containers

## 9.5 Understanding OTA Flow
* First, all operators need to be updated to the newer version
* Next, the CoreOS images can be updated
  * The node will first pull the new image
  * Next, the image is written to disk
  * Then the bootloader is changed to boot the new image
  * To complete, the CoreOS machine reboots

##### Manually Updating the Cluster
* **oc get clusterversion** will show the curreifnt version
* **oc adm upgrade** will show if an upgrade is available
* **oc adm upgrade --to-latest=true** will upgrade to the latest version
* **oc adm upgrade --to=version** will upgrade to a specific version
* **oc get clusterversion** aloows to verify the update
* **oc get clusteroperators** will show if operators are in the right state
* **oc describe clusterversion** will show an overview of past upgrades

## Lesson 9 Lab

```bash
oc get nodes > /tmp/health.txt
```

```bash
oc describe nodes  >> /tmp/health.txt
```

```bash
oc get co >> /tmp/health.txt
```

```bash
oc get clusterversion >> /tmp/health.txt
```

