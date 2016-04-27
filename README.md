# Kong as a Docker Service

This an extension of the [official Docker image][docker-kong-url] for [Kong][kong-url], with support to for [Rancher][rancher-url], [Kubernetes][kubernetes-url], or [Tutum/Docker Cloud][docker-cloud-url].


# Justifications

## Extra Environment Variables
The official `docker-kong` image allows for:

    1. linking `Cassandra` or `Postgres` database containers
    2. connecting to external databases via custom `kong.yml` config file by replacing the `/etc/kong/` volume.

However when using `Rancher` or `Kubernetes`, containers are organised into `Services` deployed across multiple machine node clusters. Therefore it's not feasible to mount custom config files into volumes on each machine. See related question [here][envvar-question]

By configuring `Cassandra` and `Postgres` purely using Environment Variables, it is a lot easier to point to an external RDS or InstaClustr instance.

## IP Address discovery
This image also supports using [Rancher Meta Data Service][rancher-metadata-service] to work out the correct container ip address for `cluster_listen` (instead of incorrectly defaulting to 0.0.0.0:7946). Other platforms can be extended quite easily.

# Supported tags and respective `Dockerfile` links

- `0.8.0` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.0/Dockerfile))*
- `latest` - *([Dockerfile](https://github.com/littlebaydigital/docker-kong-service/blob/0.8.0/Dockerfile))*

# How to use this image

Existing `docker-kong` usages still applies. The following Cassandra and Postgres Environment Variables are added:

## Cassandra Environment Variables: 

```shell
$ docker run -d --name kong \
    -e "DATABASE=cassandra" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    -e CASSANDRA_CONTACT_POINTS=\"52.5.149.55:9042\",\"52.5.149.56:9042\"
    -e CASSANDRA_KEYSPACE=kong
    -e CASSANDRA_USER=cassandra
    -e CASSANDRA_PASSWORD=cassandra
    --security-opt seccomp:unconfined \
    littlebaydigital/kong
```

## Postgres Environment Variables:

```shell
$ docker run -d --name kong \
    -e "DATABASE=cassandra" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    -e POSTGRES_HOST=localhost
    -e POSTGRES_PORT=5432
    -e POSTGRES_DB=kong
    -e POSTGRES_USER=kong
    -e POSTGRES_PASSWORD=kong
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