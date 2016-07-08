# Kong as a Docker Service
[![Docker Repository on Quay](https://quay.io/repository/littlebaydigital/kong/status "Docker Repository on Quay")](https://quay.io/repository/littlebaydigital/kong)

[Docker Hub Link](https://hub.docker.com/r/littlebaydigital/kong/)

This an extension of the [official Docker image][docker-kong-url] for [Kong][kong-url], with support to for [Rancher][rancher-url], [Kubernetes][kubernetes-url], or [Tutum/Docker Cloud][docker-cloud-url].

You can also spin this up by adding in my custom [Rancher Catalog](https://github.com/LittleBayDigital/littlebay-rancher-catalog)

# Justifications

The official `docker-kong` image allows for:

    1. linking `Cassandra` or `Postgres` database containers
    2. connecting to external databases via custom `kong.yml` config file by replacing the `/etc/kong/` volume.

However when using `Rancher` or `Kubernetes`, containers are organised into `Services` deployed across multiple machine node clusters. Therefore it's not feasible to mount custom config files into volumes on each machine which are spun up and down on demand. See related question [here][envvar-question]

Also there is no need to explicitly link containers since internal DNS resolutions for Services comes out of the box in platforms such as `Rancher` or `Tutum`. 

By configuring `Cassandra` and `Postgres` purely using Environment Variables, it is a lot easier to point to either an external database instance or an internal database service. Without having to build a custom kong config.

# Supported tags and respective `Dockerfile` links

- `0.8.0` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.0/Dockerfile))*
- `0.8.1` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.1/Dockerfile))*
- `0.8.2` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.2/Dockerfile))*
- `0.8.3` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.3/Dockerfile))*
- `latest` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.3/Dockerfile))*

# How to use this image

Existing `docker-kong` usages still applies. The following extra Environment Variables are added:

### Kong Environment Variables:
| Env Var | Default | Description |
| --------|---------| ------------|
| DATABASE | cassandra | either cassandra or postgres as per official image |
| CLUSTER_LISTEN | 0.0.0.0:7946 | host ip and port. When `rancher` is specified, the [Rancher Meta Data Service][rancher-metadata-service] to work out the correct container ip address for `cluster_listen`. Other platforms can be extended quite easily. |

### Cassandra Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| CASSANDRA_CONTACT_POINTS | kong-database:9046 | Mandatory. Specify custom values in the format of `\"ip1:9046\",\"ip2:9046\"` or use a internal service name |
| CASSANDRA_KEYSPACE | kong | Optional |
| CASSANDRA_USER | kong | Optional |
| CASSANDRA_PASSWORD | kong | Optional |

Example:

```shell
$ docker run -d --name kong \
    -e DATABASE=cassandra \
    -e CASSANDRA_CONTACT_POINTS='\"52.5.149.55:9042\",\"52.5.149.56:9042\"' \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    littlebaydigital/kong
```

or:

```shell
$ docker run -d --name kong \
    -e DATABASE=cassandra \
    -e CASSANDRA_CONTACT_POINTS='\"cassandra-service.kong-stack:9042\"' \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    littlebaydigital/kong
```

Sample Docker Compose: https://github.com/yunspace/my-docker-stacks/tree/master/kong/cassandra

### Postgres Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| POSTGRES_HOST | kong-database | Mandatory. Either a external hostname or internal service name |
| POSTGRES_PORT | 5432 | Optional. |
| POSTGRES_DATABASE | kong | Optional. |
| POSTGRES_USER | kong | Optional. |
| POSTGRES_PASSWORD | kong | Optional. |

Example:

```shell
$ docker run -d --name kong \
    -e DATABASE=postgres \
    -e POSTGRES_HOST=127.0.0.1 \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    littlebaydigital/kong
```

or: 

```shell
$ docker run -d --name kong \
    -e DATABASE=postgres \
    -e POSTGRES_HOST=postgres-service.kong-stack \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    littlebaydigital/kong
```

Sample Docker Compose: https://github.com/yunspace/my-docker-stacks/tree/master/kong/postgres

[kong-url]: http://getkong.org
[docker-kong-url]: https://hub.docker.com/r/mashape/kong/
[rancher-url]: http://rancher.com/
[rancher-metadata-service]: http://rancher.com/introducing-rancher-metadata-service-for-docker/
[kubernetes-url]: http://kubernetes.io/
[docker-cloud-url]: https://www.docker.com/products/docker-cloud
[envvar-question]: https://groups.google.com/forum/#!topic/konglayer/mfjBUwQHHHk
