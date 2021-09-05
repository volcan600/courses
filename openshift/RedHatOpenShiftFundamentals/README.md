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
