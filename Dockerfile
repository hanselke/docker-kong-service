FROM centos:7
MAINTAINER Hansel ke, hansel@openb.net

ENV KONG_VERSION 0.10.2

RUN yum install -y https://github.com/Mashape/kong/releases/download/$KONG_VERSION/kong-$KONG_VERSION.el7.noarch.rpm && \
    yum clean all

COPY config.docker/kong.yml /etc/kong/

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start","-vv"]