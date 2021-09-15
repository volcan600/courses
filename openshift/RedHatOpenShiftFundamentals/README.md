# [Red Hat OpenShift Fundamentals, 3/e](https://learning.oreilly.com/videos/red-hat-openshift/9780135767436/)

## Module 1: Container Fundamentals

### 1.1 Understanding Containers

### 1.2 Understanding Container Architecture
* cgroups: restructions to resources usage
* SeLinux
* namespaces

### 1.3 Understanding the container Engine
* Different container engines are provided
  * Podman
  * Systemd
  * Docker
  * LXC

#### Understanding Container Runtimes
* The container runtime is a specific part of the container engine, and two of them are commonly used:
  * CRI-o: Red Hat
  * containerd: originates from Docker
* The container runtime is taking care of specific tasks
  * Provide the mount point
  * Communicate with the kernel
  * Set up cgroups and more

### 1.4 Understanding Container Needs in the Datacenter
* Solution to run container in data center environment is the orchestration

### 1.5 Understanding Kubernetes and OpenShift
* Source-to-Image
* Routes
* Operators
* etc

### Lesson 1 Lab: Installing Classroom Machies
* On developers.redhat.com, create a free developer account
* Install a virtual machine, running the latest version of RHEL, using the following specifications
  * 4 GB RAM
  * 2 CPUs
  * 40 GB Store
  * Server with GUI installation parttern
  * Direct Internet connection

#### 2.1 Running Container on Podman/CRI-o
* Notice that access to Red Hat registries requires credentials
  * Use **podman login** when using a non-root shell
  * Automatic from a root shell

##### Demo: Running a container
* **sudo yum module install container-tools**
* **sudo podman search ubi**
* **sudo podman pull ubi8/ubi**
* **podman images** # doesn't show it
* **podman run ubi8**
* **podman ps**
* **podman ps -a**
* **podman run ubi8/ubi echo hello world**
* **podman run nginx; Ctrl-C**
* **podman run -d nginx**
* **podman run -it ubi8/ubi /bin/bash**

```bash
sudo yum module install container-tools
```

```bash
sudo podman search ubi
```

```bash
sudo podman pull ubi8/ubi
```

```bash
podman ps -a
```

```bash
podman run ubi8/ubi echo hello world
```

```bash
# Exit using Ctrl-C
podman run nginx
```

```bash
# Run on background
podman run -d nginx
```

```bash
podman run -it ubi8/ubi /bin/bash
```

### 2.3 Understanding Rootless Containers
* Rootless container are secured
* Rootless have limited access to the filesystem
* Rootless container does not allocate IP address

```bash
podman run -d nginx
```


```bash
# -l option means last container
podman inspect -l -f "{{.NetworkSettings.IPAddress}}"
```

```bash
sudo podman run -d nginx
```

```bash
# -l option means last container
sudo podman inspect -l -f "{{.NetworkSettings.IPAddress}}"
```

### 2.3 Understanding Container and the Host OS

#### Containers on the Host OS
* Use **ps fax | less** and look for processes that are started by **runc** which is the container runtime
* Containers use the same kernel than hardware


### 2.4 Providing Variables at Container Start

#### Using Variables
* The most straightforward way to provide these variables is by starting the container with the **-e key=value** option
* To analyze if a container needs additional information while starting, use the **podman logs containername** command

#### Demo: Running mariadb

```bash
sudo podman run mariadb
```

```bash
sudo podman ps -a
```

```bash
sudo podman logs <containername>
```

```bash
man -k podman
man podman-run
```

```bash
sudo podman run -d -e MYSQL_ROOT_PASSWORD=password mariadb
```

```bash
sudo podman ps -a
```

### Lesson 2 Lab: Running Containers
* Use the appropriate command to find the ubi8 image
* Download the image without running it
* Inspect the image to find out what is used as default entrypoint
* Open the image in a interactive shell, and find which operating system and kernel it uses

```bash
podman search ubi8
```

```bash
podman pull ubi8
```

```bash
podman images
```

```bash
podman inspect ubi8 | less
```

```bash
podman run -it ubi8 cat /etc/*-release
```

```bash
uname -r
```



### 3.1 Using Registries
* An image registry is like a Git repository 

#### Configuring Registry Access
* The /etc/containers/registries.conf file provides access to registries
* After authentication, images can be accessed using **podman pull** or **podman run: podman pull quay.io/bitnami/nginx**


```bash
# Enable redhad repo
podman login registry.redhat.io
```

```bash
podman search nginx
```

```bash
podman pull registry.redhat.io/ubi8/nginx-118
```

### 3.2 Saving and Loading images
* Use **podman save** to save an image to a .tar file: **podman save quay.io/bitnami/nginx:latest -o mysql.tar**
* To load a container image from a tar file, use **podman load -i mysql.tar**

### 3.3 Working with Tags

```bash
skopeo inspect -h 
```

```bash
# Search RepoTags keyword
skopeo inspect docker://registry.redhat.io/rhosp15-rhel8/openstack-mariadb
```

#### Creating Tags
* Use **podman tag** to apply a tag to an image: **podman tag nginx mynginx:db**

### 3.4 Sharing Images

#### Understanding Sharing Options
* Standard image are downloaded from registries
* To easiest wa y to apply modifications to images is by using **podman commit**
* Using Dockerfile is preferred though
  * **commit** keeps logs and more runtime information in the captured images
  * **commit** requires you to work with complete images, whereas Dockerfile is just a description of the work to be done to create images
* Before using **podman commit**, use **podman diff** to get a list of differences between the running container and the original image

```bash
podman run --name newnginx -d nginx
```

```bash
podman exec -it newnginx bash
```

```bash
echo hello > /tmp/hello
```

```bash
podman ps
```

```bash
podman  diff newnginx
```

```bash
podman commit newnginx newnginx:latest
```

### Lesson 3 Lab: Managing Images
* Ensure you are logged in to all registries required to use podman
* Search for information about the ubi8 image
* Download the image you've found, and make a backup copy of it
* Investigate image contents
* Remove the image from the local image list
* Restore the backup you prevously created

```bash
podman login registry.redhat.io
```

```bash
podman search ubi8
```

```bash
skopeo inspect docker://registry.access.redhat.com/ubi8/ubi-minimal
```

```bash
podman save -o ubi-minimal.tar ubi-minimal:latest
```

```bash
podman image rm --force `podman image ls | awk '{print $3}'`
```

```bash
podman load -i ubi-minimal.tar
```

### 4.1 Getting Container Status Information
* Review of basic podman commands

### 4.2 Executing Commands in Containers
* **podman exec mycontainer bash**
* **podman run mycontainer --entrypoint=bash**
* Inside of container, check cat /proc/1/cmdline to check the entrypoint command


### 4.3 Attaching Storage to Containers
* No persistent and persitent volumes

### 4.4 Managing SELinux Context on the Host
* If container are started with a specific UID, the numeric UDI can be set
  * Use **podman inspect image** and look for **User** to find which user this is
Next, use **sudo chown -R \<id\>:\<id\> /hostdir** and set the User ID found in the container
* Then set SELinux:
  * **sudo semanage fcontext -a -t container_file_t"/hostdir(/.\*)?"**
  * **sudo restorecon -Rv /hostdir**
* And mount the storage using **podman run -v /hostdir:/dir-in-container myimage**

```bash
podman search mysql
```

```bash
podman login registry.access.redhat.com
```

```bash
sudo podman pull registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
sudo podman inspect  --format "{{.User}}" registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
# it need sufficient permissions to access to the mound point
grep 27 /etc/passwd
```

```bash
sudo mkdir /srv/dbfiles
```

```bash
sudo chown -R 27:27 /srv/dbfiles
```

```bash
sudo semanage fcontext -a -t container_file_t "/srv/dbfiles(/.*)?"
```

```bash
sudo restorecon -Rv /srv/dbfiles
```

```bash
sudo ls -ldZ /srv/dbfiles
```

```bash
sudo podman run -d -v /srv/dbfiles:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
ll /srv/dbfiles
```

#### Configuring SELinux Automatically
* To ensure correct SELinux labels, they can be set using **semange fcontext** and **restorecon** as describe before
* This works in all cases and for that reason is the preferred way
* If the user that runs the container is owner of the directory that is going to be bind-mounted, the **:Z** option can be used to automatically set the appropriate SELinux context
* This is the recommended approach while using rootless containers
* **podman run -d -v /srv/dbfiles:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password registry.access.redhat.com/rhscl/mysql-57-rhel7**

```bash
mkdir ~/dbfiles
```

```bash
podman run -d -v ~/dbfiles:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password registry.access.redhat.com/rhscl/mysql-57-rhel7
```

### 4.4 Understanding SELinux and containers
* To understand better watch the video again or red the [SELinux coloring book](https://people.redhat.com/duffy/selinux/selinux-coloring-book_A4-Stapled.pdf)


### 4.5 Exposing Container Workloads
* Rootless containers don't have an IP address and are accessible through port forwarding on the container host only
* Root containers connect to a brigde, using a container-specific IP address
* Containers behind the bridge are not directly accessible

#### Understanding Podman SDN
* Podman uses the CNI to implement a Software Defined Network (SDN)
* According to the /etc/cni/net.d/87-podman-bridg e.conflist, a bridge is used for this purpose

#### Exposing Container Applications
* **sudo podman run -d 8088:80 nginx** runs an Nginx container on port 80, where port 8088 can be addressed on the host to access its workload
* In port forwarding, a source IP address can be specified to allow access only it traffic comes from a specific IP address: **sudo podman run -d -p 127.0.0.1:8088:80 nginx**
* Use **sudo podman port** to find which port mapping applies to a specific container

#### Demo: Exposing Container Ports

```bash
sudo podman -d -p 8088:80 nginx
```

```bash
sudo podman ps
```

```bash
curl localhost:8088
```

### Lesson 4 Lab: Managing Containers
* Run a MySQL container using persitent storage and port forwarding in such a way that traffic sent to host port 13306 is forwarded to container port 3306. Make sure that all required parameters are used to start a database with name books, which is accessible by the user linda


```bash
sudo mkdir /srv/mysql
```

```bash
sudo podman inspect  --format "{{.User}}" registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
sudo chown 27:27 /srv/mysql
```

```bash
sudo semanage fcontext -a -t container_file_t "/srv/mysql(/.*)?"
```

```bash
sudo podman run -d -v /srv/mysql:/var/lib/mysql -p 13306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=linda -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=books registry.access.redhat.com/rhscl/mysql-57-rhel7
```

### 5.1 Options for working with Custom Container Images


### 5.2 Using podman commit
* As it lacks traceability, and keeps unnecessary files in the image, this is not the preferred way to create images
* Use Dockerfile or **buildah** commands instead

### 5.3 Building Custom Images with Dockerfile
* Each Dockerfile starts with FROM, identifying the base image to use
  * Next instructions are executed in that base image
  * Instructions are executed in order as specified
* Each Dockerfile instruction runs in an idependent container, using an intermediate image built from a previous command, which means that adding multiple instructinos results in multiple layers

```bash
git clone https://github.com/sandervanvugt/ex180
```

### 5.4 Understanding Dockerfile Instructions
* ENTRYPOINT is the default command to be processed
* If not specified, **/bin/sh -c** is execited as the default command
* Arguments to the ENTRYPOINT command should be specified separately using CMD
  * ENTRYPOINT \["command"\]; **ENTRYPOINT["/usr/sbin/httpd"]**
  * CMD\["arg1","arg2"\];**CMD["-", "FOREGROUND"]**
* If the default command is specified using CMD instead of ENTRYPOINT, the command is executed as an argument to the default entrypoint **sh -c** which can give unexpected results
* If the arguments to the command are specified within the ENTRYPOINT, then they cannot be overwritten from the command line; so to make your Dockerfile flexible make sure to pass the command arguments separately in a CMD section

#### Other Dockerfile Instructions
* FROM indentifies the base image to use
* LABEL is a key-value pair that is used for identification
* MAINTAINER is the name of the person that maintains the image
* RUN executes command on the FROM image
* EXPOSE has metadata-only information on where the image should run 
* ENV defines enviroment variable to be used within the container
* ADD copies files from the project directory to the image
* COPY copies files from the local project directory, using ADD is preferred
* USER specifies username from RUN, CMD and ENTRYPOINT instructions

#### Understanding Formats
* Options like ADD, COPY ENTRYPOINT, CMD are used in shell form and in exec from
* Shell form is a list of items
  * ADD /myfile /mydir
  * ENTRYPOINT /usr/bin/nmap -sn 172.17.0.0/24
* EXEC form is a JSON array of items
  * ADD\["myfile", "/mydir"\]
  * ENTRYPOINT\["/usr/bin/nmap", "-sn", "172.17.0.0/24"\]
* Using Exec form is preferred, as shell form wraps command in a /bin/sh -c shell, which creates a sometimes unnecessary shell process

### 5.5 Avoiding Multi-layer Images
* Each command used in a Dockerfile creates a new layer and this should be avoided
* When installing software from a Containerfile, use **dnf clean all -y** to clean yum caches
* Exclude documentation and unnecessary dependencies using the **--nodocs --setopt install_weak_deps=False** option to **dnf install**
* Don't use regular base image but minimal base image, use **ubi-minimal** instead of the regular ubi image


### 5.6 Managing Images with buildah and skopeo
* **skopeo** can be used to manage images from image repositories
* Useful options are:
  * **skopeo inspect** to inspect images as they are stored in an image repository
  * **skopeo copy** to copy images between registries and between local files and registries
* In an OpenShift environment, **skopeo** can be used to push images to the local OpenShit registry


#### Understanding Buildah
* **Buildah** can be used to create and manage custom images
* Image management functionality is also integrated in **podman**
* **buildah** has the advantage that it includes a scripting language, which allows you to build an image from scracth, such that it is not based on any base image

#### Demo: Creating an Image Using buildah

```bash
buildah from ubi]/ubi:latest
```

```bash
buildah images
```

```bash
buildah containers
```

```bash
curl -sSL http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz -o hello-2.10.tar.gz
```

```bash
buildah copy ubi-working-container hello-2.10.tar.gz /tmp/hello-2.19.tar.gz
```

```bash
buildah run ubi-working-container yum install -y tar gzip gcc make
```

```bash
buildah ubi-working-container yum clean all
```

```bash
buildah run ubi-working-container tar zxvf /tmp/hello-2.10.tar.gz -C /opt
```

```bash
buildah config --woringdir /opt/hello-2.10 ubi-working-container
```

```bash
buildah run ubi-working-container ./configure
```

```bash
buildah run ubi-working-container make
```

```bash
buildah run ubi-working-container make install 
```

```bash
buildah run ubi-working-container hello -v
```

```bash
buildah config --entrypoint /usr/local/bin/hello ubi-working-container
```

```bash
buildah commit --format docker ubi-working-container hello:latest
```

```bash
buildah images
```

### Lesson 5 Lab Creating Custom Images
* Use a Dockerfile to create an image that runs the Apache httpd server, based on the ubi8 image. While building, add the nmap software package to the image, as well as the httpd package, and ensure that no yum cache is stored. Set the httpd service to the default process that will be started. It should start as a foreground process. After building it, run the image

```bash
mdir lessing5
```

```yaml
FROM ubi8/ubi
MAINTAINER Marlon
LABEL description="custom apache server"

RUN  yum install -y httpd nmap &&\
     yum clean all &&\
     echo "Hello from custom webserver" > /var/www/html/index.html

EXPOSE 80

EXNTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]
```

```bash
podman build --layers=false -t custom=apache .
```


### 7.1 Understanding Application Resources
* Api's
* Deployment
* Replicaset
* Pod
* Container
* Volumes
* Service
* Configmap
* Secret
* Route
* PV
* PVC
* Storageclass

### 7.2 Exploring API
* **oc api-resources**
* **oc explain**

### 7.3 Deploying an Application in OpenShift
* Before creating applications, use **oc new-project** to create new projects
* Use **oc projects** or **oc get ns** as administrator to get an overview of all projects
* **oc new-app** is the primary tool for running applications
* **oc create deployment** can be created as an alternative
* **oc get all** to find all application resources
* To get an overview of resources in all projects, use **oc get all -A**

### 7.4 Displaying Information about Running Applications

#### Demo: Displaying Application Information

```bash
# Show pods information
oc get all
```

```bash
oc get all
```

```bash
oc get pods -A
```

```bash
oc get pods mypod -o yaml
```


```bash
oc describe pods mypod
```

```bash
oc logs mypod
```

### 7.5 Using Labels
* Labels are automatically or manually applied to workloads in OpenShift


#### Demo: Using labels

```bash
oc projects
```

```bash
oc project lab
```

```bash
oc get all
```

```bash
oc get pods.rs --show-labels
```

```bash
oc get pods.rs --selector app=labnginx
```

```bash
oc label pod <podname> storage=ssd
```

### 7.6 Using OpenShift in the Declarative Way

#### Understanding Declarative vs. Imperative
* In an imperative way of working, an operator types commands to get things done
* In a declarative way of working, the configuration is managed as code

### Creating YAML Files
* The recommended way to create YAML files is by generating them: **oc create deploy mynginx --image=bitnami/nginx --dry-run=client -o yaml > mynginx.yaml**

```bash
oc create deploy mynginx --image=bitnami/nginx --dry-run=client -o yaml > mynginx.yaml
```

### 7.7 Using Service to Access Pods

#### Understanding Services
* In OpenShift, a Pod SDN is provided for Pod access
* Pod IP addresses are volatile
* For that reason, Pods are not addressed directly, but services are used instead
* Services are exposed on the cluster IP address
* Services also provide load balancing when multiple Pods are used in a replicated setup
* Clustername can be obtained using **oc config get-clusters** or **oc config current-context**
* Different types of services can be used
  * ClusterIP provides an IP address that is only accessible on the ClusterIP. Ths IP address cannot be addressed directly by external users
  * NodePort provides a node port on the cluster nodes which allows users to connect to the service directly
* In OpenShift, services are not addressed directl. Use routes instead
* **oc port-forward** can be used to expose a Pod port on the local workstation where the oc client is used. This is good for administrator/developer
access, but not to expose workloads to external users
  * **oc port-forward mynginx 8080:80**

### 7.8 Using Routes to Provide Access to Applications
* Routes use services to provide access to Pods
* To do so, router Pods are deployed on infrastructure nodes
* Router Pods bind to the node public IP addresses, from where traffic can be forwarded to services, thus providing access to the Pods
* DNS must be configured to enable traffic forwarding to the appropriate public node IP address
* In the route spec, two important fields are used
  * spec.host: the DNS name that is used by the route to expose itself
  * spec.to: the name of the service resource
* Routes can be configured to handle TLS traffic

#### Creating Routes
* **oc expose service <servicename>** is used to create routes
* The **oc expose** command generates a DNS name that looks like routename.projectname.defaultdomain
* The default domain is a wildcard DNS domain that is configured while installing OpenShift, and matches the OpenShift DNS name
  * On CRC, the default domain is set to apps-crc.testing
* The external DNS server needs to be configured with a wildcard DNS name that resolves to the load balancer that implemtns the route

#### Exploring the Default Router
* OpenShift runs a default router in the openshift-ingress namespace
* The ROUTER_CANONICAL_HOSTNAME variable defines how this router is accessible from the outside
  * **oc get pods -n openshift-ingress**
  * **oc describe pods -n openshift-ingress router-defaultp[Tab]**

#### Demo: Exposing a Service as route

```bash
# As administrator
oc get all -n openshift-ingress
```

```bash
oc login -u developer -p developer
```

```bash
oc new-project myroute
```

```bash
oc new-app bitnginx --as-deployment-config bitnami/nginx
```

```bash
oc get all
```

```bash
oc describe svc bitnginx
```

```bash
oc expose svc bitnginx
```

```bash
oc describe route
```

```bash
oc get pods -o wide
```

```bash
curl http://<checkondescribestep>
```

### Lesson 7 Lab: Running Applications in OpenShift
* Use **oc new-app** to run the rhscl/mysql-57-rhel7:latest image as a deployment config. This is likely to fail. Analyze what is goind wrong, and make sure the application is started the right way.

### 8.1 Understanding Decoupling

#### Understanding Microservices
* A microservice is an application that consists of several independent components that are individually managed.
* The different components in a microservice need to be connected to each other by providing site-specific information.

#### Understanding OpenShift Decoupling Resources
* Services provide a single point of access that is used as load balancer to provide 
* Templates can be used to define a set of resources that belong together, as well as application parameters
* ConfigMaps and Secrets can be used to provide a set of variables, parameters, and configuration files that can be used by application resources
* Persistent Volume Claims (PVCs) are used to connect to storage that is available in a specific environment

### 8.2 Using ConfigMaps for Decoupling

#### Understanding ConfigMaps
* The purpose of a ConfigMaps is decoupling
* Decoupling means that static data is kept apart from site-specific dynamic data
* ==ConfigMaps and Secrets are very similar, but information in Secrets is Base64 encoded, which is not the case for ConfigMaps==
* ConfigMaps are used to store the following types of values:
  * Variables
  * Application startup parameters
  * Configuration Files

#### Demo: Using a ConfigMap for ConfigFiles
```bash
oc new-project cmap
```

```bash
oc create deploy mynginx --image=bitnami/nginx
```

```bash
oc get pods
```

* **This command copy from the pod to the local machine. Similar to scp command**
```bash
oc cp <podname>:/app/index.html index.html
```

* Apply modifications to index.html 

```bash
oc create configmap mycm --from-file=index.html
```

```bash
oc set volume deploy mynginx --add --type=configmap --configmap-name mycm --mount-path=/app/
```

```bash
oc expose deploy mynginx --type=NodePort --port=8080
```

```bash
oc get svc
```

```bash
curl http://&(crc ip):<nodePort>
```

```bash
oc get deploy myninx -o yaml
```

#### Demo: Using a ConfigMap for Variables
```bash
oc create deploy mymariadb --image=registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
oc logs mymariadb-<ID>
```

```bash
oc create configmap myvars --from-literal=MYSQL_ROOT_PASSWORD=password
```

```bash
oc describe configmap myvars
```

```bash
oc set env deploy mymariadb --from=configmap/myvars
```

```bash
oc describe deploy mymariadb
```

```bash
oc get deploy mymariadb -o yaml
```

### 8.3 Working with Secrets

#### Understanding Secrets
* A secret is a based64 encoded ConfigMap
* Encoded is not secured, the data is just coded and it's easy to revert to the original data
* Secrets are used a lot internally in OpenShift

```bash
podman login docker.io
```

```bash
oc create secret generic docker --from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json --type kubernetes.io/dockerconfigjson
```

```bash
oc describe secret docker
```

```bash
oc get secret docker -o yaml
```

```bash
oc secrets link default docker --for pull
```

### 8.4 Providing Persistent Storage

#### Using Persisten Volumes
* A Persistent Volume Claim (PVC) is used to request access to storage
* Applications are configured to used a specific PVC by referring to their name
* To better determine what to connect to, StorageClass can be used as a matching label between the PV and the PVC
* After requesting access to the PV, the PVC will show as bound

* Use admin user
```bash
oc create -f pv.yaml
```

```bash
oc create -f pvc.yaml
```

```bash
oc create -f pv-pod.yaml
```

#### Configuring Persisten Storage with Templates
* Many templates are offered with a -persistent suffix, and offer access to persistent storage
  * **oc get templates -n openshift | grep persistent**
* These templates contain a Persistent VolumeClain resource, that only need to know which type and how much storage is required
* While using such templates, you only need to sepecify the required capacity, using the VOLUME_CAPACITY parameters

### 8.5 Using Templates

#### Understanding Templates
* When application is defined, typically a set of related resources using the same parameters is created
* Templates can be used to make creating these resources easier
* Resource attributes are defined as template parameters

#### Exploring OpenShift Templates
* OpenShift comes with a set of default templates, use **oc get templates -n openshift** to show them
* Each template contains specific sections
  * The **objects:** section defines a list of resources that will be created
  * The **parameters:** section defines parameters that are used in the template objects
* Available parameters can be shown from the command line
 * Use **oc describe template templatename** to list parameters that are used
 * Use  **oc process --parameters templatename**

#### Generating Applications from Templates
* To generate an application from a template in the OpenShift namespace, your first need to export the template
  * **oc get template mariadb-ephemeral -o yaml -n openshift > mariadb-ephemeral.yaml**
* Next, you need to indenfity parameters that need to be set, and process the template with all of its parameters
  * **oc process --parameters mariadb-ephemeral -n openshift**
  * **oc process -f mariadb-ephemeral.yaml -p MYSQL_USER=anna -p MYSQL_PASSWORD=password -p MYSQL_DATABASE=books | oc create -f -**

#### Using oc new-app with Templates
* The **oc new-app** option **--template** allows you to create an application from a template directly, using **oc new-app**
* Notice that applications created from templates with **oc new-app** must use **--as-deployment-config** in most cases, as most templates create dc's and not deployments
* **oc new-app --template=mariadb-ephemeral -p MYSQL_USER=anna -p MYSQL_PASSWORD=anna -p MYSQL_DATABASE=videos --as-deployment-config**

### 8.6 Connecting Applications to Create Microservices

#### Demo: Setting up mysql
```bash
oc login -u developer -p password
```

```bash
oc new-project microservice
```

```bash
oc create secret generic mysql --from-literal=password=mypassword
```

```bash
oc new-app --name mysql registry.access.redhat.com/rhscl/mysql-57-rhel7
```

```bash
oc set env deployment mysql --prefix MYSQL_ROOT_ --from secret/mysql
```

```bash
oc set volumes deployment/mysql -name mysql-pvc -add --type pvc --claim-size 1G --claim-mode rwo --mount-path /var/lib/mysql
```

#### Demo: Setting up Wordpress
```bash
oc new-app --name wordpress --docker-image bitnami/wordpress
```

```bash
oc expose svc wordpress
```

```bash
oc create cm wordpress-cm --from-literal=host=mysql --from-literal=name=wordpress --from-literal=user=root --from-literal=password=password
```

```bash
oc set env deploy wordpress --prefix WORDPRESS_DATABASE_ --from configmap/wordpress-cm
```

```bash
oc exec -it wordpress-[Tab] --env
```

```bash
oc get routes
```

### Lesson 8 Lab: Running Microservices in OpenShift
* Run a mariadb database with 3 replicated Pods. Ensure that the /var/lib/mysql directory is stored eternally, using a claim for 1GB of storage. Also make sure that the MYSQL_ROOT_PASSWORD variable is set to "password", using ConfigMap

```bash
oc new-project lab8
```

```bash
oc process --parameters mariadb-persistent -n openshift
```

```bash
oc new-app --template=mariadb-persistent -p MYSQL_ROOT_PASSWORD=password -p VOLUME_CAPACITY=1Gi -p MEMORY_LIMIT=2Gi --as-deployment-config
```

### 9.1 Managing Source Code in Git

#### Demo: Using Git
* Use **git clone https://github.com/sandervanvugt/simpleapp** to create a local copy of the remote simpleapp repo
* Use **cd simpleapp; rm -rf .git** to remove all Git data from it. This would make your own
* On the Git website, create a new repo with the name simpleapp
* Follow instrucctions to generate Git metadata in /simpleapp 
  * **git init**
* Use the following to upload everything to your own Git repo:
  * **git add .**
  * **git commit -m "my first commit"**
  * **git remote add origin https://github.com/<YOURACCOUNT>/simpleapp**
  * **git push -u origin master**

### 9.2 Understanding S2I
* Source-to-image (S2I) is the tool that takes application source code from a Git repository, injects this source code in a base container that is based on the source code languange and framework, and produces a new container image that runs the application
* Using S2I makes working with OpenShift easier
  * The developer doesn't have to know anything about Dockerfile or platform specifics
  *  Pacthing is made easy: just run the process again

### 9.3 Building an Application from Source
* When creating an application with S2I, you can set the ImageStream that should be used
* If just the git repo and not ImageStream is specified, OpenShift will try to detect appropriate ImageStream
* **oc -o yaml new-app php~https://github.com/<YOURACCOUNT>/simpleapp --name=simple > s2i.yaml**
* **view s2i.yaml**
* **oc apply -f s2i.yaml**
* **oc status**
* **oc get builds**
* **oc get pods**
* **oc expose svc simple**
* **oc get routes**

### 9.4 Analyzin the S2I Procedure

#### Demo: Analyzin the build Procedure
* **oc get builds**
* **oc logs bc** or **oc logs bc/simple**
* **oc get buildconfig simple**
* **oc start-build simple** \# will trigger a new build based on the previously created BuildConfig

### 9.5 Understanding ImageStream

#### Demo: Exploring Images in OpenShift
* **oc new-app quay.io/bitnami/nginx -o yaml**
* **oc new-app quay.io/bitnamo/nginx**
* **oc get is**
* **oc get is nginx -o yaml**
* **oc login -u kubeadmin**
* **oc get images; oc get images | grep bitnami/nginx**

#### Creating New Apps Based on ImageStream
* When a new application is created with **oc create deploy** or **oc new-app**, the image registries will be contacted to check for a newer image
* To prevent this, use **--image-stream** to refer to an existing ImageStream and use the image from the internal image registry
* Use **oc new-app** -L to list all existing image streams and tags included
* Within the ImageStream, different tags are provided. The tags can be combined with the **--image-stream** argument
* Use for instance **oc new-app --name=whatever --image-stream=nginx:1.18-ubi8**

### 9.6 Triggering Updates

#### Demo: Manually Triggering Updates
* Access the application built previously through its route
  * Use **oc expose svc simple** if necessary
  * **curl <name-of-the-route>**
* Edit the **index.html** in the **simple** git cloned directory
* Use git add, git commit, git push to push changes to GitHub
* Use **oc start-build simple** to trigger the build procedure again
* Monitor, using **oc get all**. Make sure nothing is in a state of Pending
* **curl <name-of-the-route>** to verify changes

### Lesson 9 Lab: Building Applications from Source
* Create a copy of https://github.com/sandervanvugt/simpleapp** in your own Git account
* Based on the code in your Git account, use S2I to build an application
* Create a route to test access to the application
* Modify the index.php to show a simple hello world message and push changes to your git account
* Run the build process again, and verify access to the application

```bash
oc new-project lab9
```

```bash
oc new-app php~https://github.com/<YOURACCOUNT>/simpleapp --name=simpleapp
```

```bash
oc get all
```

```bash
oc expose svc simple
```

```bash
oc get routes
```

```bash
vim simpleapp/index.html
```

```bash
git add .
```

```bash
git commit -m "second commit to update the application"
```

```bash
git push
```

```bash
oc start-build simple
```

```bash
oc get all
```

```bash
!cur
```
