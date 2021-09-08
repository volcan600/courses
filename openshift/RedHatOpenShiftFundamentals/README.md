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

