## Zabbix proxy Dockerfile

This repository contains **Dockerfile** of [Zabbix proxy](http://www.zabbix.com/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/nbarnum/zabbix-proxy/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Base Docker Image

* [ubuntu:14.04](https://registry.hub.docker.com/_/ubuntu/)

### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/nbarnum/zabbix-proxy/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull nbarnum/zabbix-proxy`

   (alternatively, you can build an image from Dockerfile: `docker build -t nbarnum/zabbix-proxy github.com/nbarnum/docker-zabbix-proxy`)

### Usage

#### Run `zabbix_proxy`

    docker run -d \
               --name zabbix-proxy \
               -p 10051:10051 nbarnum/zabbix-proxy \
                              -z <zabbix server ip> \
                              -s <proxy hostname to use> \
                              -m run

#### Explore running container

    docker exec -it zabbix-proxy bash
