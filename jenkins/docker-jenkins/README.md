# Jenkins Installation

## Jenkins on Docker

### Prerequisites
* Install docker engine and docker compose

### Install Jenkins using yaml files
```bash
docker network create jenkins
```

```bash
docker volume create jenkins-data
```

**docker-compose.yaml**
```yaml
version: '3.7'
services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
      - 50000:50000
    container_name: jenkins
    networks:
      - jenkins
    volumes:
      - jenkins-data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker
networks:
  jenkins:
    external: true
volumes:
  jenkins-data:
    external: true
```

```bash
docker-compose up -d
```

```bash
watch docker container ls -a
```

* When the container is running, get the initial password to set up the jenkins environment

```bash
docker exec -it jenkins  cat  /var/jenkins_home/secrets/initialAdminPassword
```
