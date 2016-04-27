# Kong as a Docker Service
[![Docker Repository on Quay](https://quay.io/repository/littlebaydigital/kong/status "Docker Repository on Quay")](https://quay.io/repository/littlebaydigital/kong)

This an extension of the [official Docker image][docker-kong-url] for [Kong][kong-url], with support to for [Rancher][rancher-url], [Kubernetes][kubernetes-url], or [Tutum/Docker Cloud][docker-cloud-url].

# Justifications

The official `docker-kong` image allows for:

    1. linking `Cassandra` or `Postgres` database containers
    2. connecting to external databases via custom `kong.yml` config file by replacing the `/etc/kong/` volume.

However when using `Rancher` or `Kubernetes`, containers are organised into `Services` deployed across multiple machine node clusters. Therefore it's not feasible to mount custom config files into volumes on each machine which are spun up and down on demand. See related question [here][envvar-question]

By configuring `Cassandra` and `Postgres` purely using Environment Variables, it is a lot easier to point to an external RDS or InstaClustr instance.

# Supported tags and respective `Dockerfile` links

- `0.8.0` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.0/Dockerfile))*
- `latest` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.0/Dockerfile))*

# How to use this image

Existing `docker-kong` usages still applies. The following extra Environment Variables are added:

### Kong Environment Variables:
| Env Var | Default | Description |
| --------|---------| ------------|
| DATABASE | cassandra | either cassandra or postgres as per official image |
| CLUSTER_LISTEN | 0.0.0.0:7946 | host ip and port. When `rancher` is specified, the [Rancher Meta Data Service][rancher-metadata-service] to work out the correct container ip address for `cluster_listen`. Other platforms can be extended quite easily. |

Example:

If using Rancher:
```shell
$ docker run -d --name kong
    -e "CLUSTER_LISTEN=rancher" \
    --link kong-database:kong-database \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    littlebaydigital/kong
```

If using a custom IP:
```shell
$ docker run -d --name kong
    -e "CLUSTER_LISTEN=52.5.149.55:7946" \
    --link kong-database:kong-database \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    littlebaydigital/kong
```

### Cassandra Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| CASSANDRA_CONTACT_POINTS | kong-database:9046 | Optional. Defaults to linked container alias. Specify custom values in the format of `\"ip1:9046\",\"ip2:9046\"`|
| CASSANDRA_KEYSPACE | kong | Optional |
| CASSANDRA_USER | kong | Optional |
| CASSANDRA_PASSWORD | kong | Optional |

Example:

```shell
$ docker run -d --name kong \
    -e "DATABASE=cassandra" \
    -e "CASSANDRA_CONTACT_POINTS=\"52.5.149.55:9042\",\"52.5.149.56:9042\"" \
    -e "CASSANDRA_KEYSPACE=kong" \
    -e "CASSANDRA_USER=cassandra" \
    -e "CASSANDRA_PASSWORD=cassandra" \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    littlebaydigital/kong
```

### Postgres Environment Variables:

| Env Var | Default | Description |
| --------|---------| ------------|
| POSTGRES_HOST | kong-database | Optional. Defaults to linked container alias |
| POSTGRES_PORT | 5432 | Optional. |
| POSTGRES_DATABASE | kong | Optional. |
| POSTGRES_USER | kong | Optional. |
| POSTGRES_PASSWORD | kong | Optional. |

Example:

```shell
$ docker run -d --name kong \
    -e "DATABASE=cassandra" \
    -e POSTGRES_HOST=127.0.0.1 \
    -e POSTGRES_PORT=5432 \
    -e POSTGRES_DB=kong \
    -e POSTGRES_USER=kong \
    -e POSTGRES_PASSWORD=kong \
    -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 7946:7946 -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    littlebaydigital/kong
```

[kong-url]: http://getkong.org
[docker-kong-url]: https://hub.docker.com/r/mashape/kong/
[rancher-url]: http://rancher.com/
[rancher-metadata-service]: http://rancher.com/introducing-rancher-metadata-service-for-docker/
[kubernetes-url]: http://kubernetes.io/
[docker-cloud-url]: https://www.docker.com/products/docker-cloud
[envvar-question]: https://groups.google.com/forum/#!topic/konglayer/mfjBUwQHHHk