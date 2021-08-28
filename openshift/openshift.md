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