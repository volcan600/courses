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

 