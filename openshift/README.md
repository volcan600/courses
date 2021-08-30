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

#### Commands
Use --from-file to put the contents of a configuration file in the ConfigMap
```kubectl create cm myconf --from-file=my.conf```

Use --from-env-file to define variables
```kubectl create cm variables --from-env-file=variables```

Use --from-literal to define variables or command line arguments
```kubectl create cm special --from-literal=VAR3=cow --from-literal=VAR4=goat```

```kubectl describe cm <cmname>```

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

```