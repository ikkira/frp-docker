FROM centos:6.9
MAINTAINER ikkira <ikkira.sc@gmail.com>

ENV VERSION 0.16.1
ENV AUTHNAME=frpuser
ENV AUTH=2rTY784BKc7

RUN yum update -y \
    && yum install -y wget

WORKDIR /tmp
RUN set -x \
    && wget https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_amd64.tar.gz \
    && tar -zxf frp_${VERSION}_linux_amd64.tar.gz \
    && mv frp_${VERSION}_linux_amd64 /var/frp \
    && yum remove -y wget

RUN echo -e "[common]\nbind_port = 7000\nvhost_http_port = 8080\ndashboard_port = 7500\ndashboard_user = ${AUTHNAME}\ndashboard_pwd = ${AUTH}\nmax_pool_count = 5\nauthentication_timeout = 900" >> /var/frp/frps.ini

VOLUME /var/frp
EXPOSE 80 443 7000 7500

WORKDIR /var/frp
ENTRYPOINT ./frps -c ./frps.ini

