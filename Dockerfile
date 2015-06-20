# Zabbix version 2.2.9

# Pull base image
FROM ubuntu:14.04

MAINTAINER Nickolai Barnum <nbarnum@users.noreply.github.com>

ENV ZABBIX_VERSION 2.2

# Install Zabbix and dependencies
RUN \
  apt-get update && apt-get -y install monit wget && \
  wget http://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-1+trusty_all.deb \
       -O /tmp/zabbix-release_${ZABBIX_VERSION}-1+trusty_all.deb  && \
  dpkg -i /tmp/zabbix-release_${ZABBIX_VERSION}-1+trusty_all.deb && \
  rm /tmp/zabbix-release_${ZABBIX_VERSION}-1+trusty_all.deb && \
  apt-get -qq update && \
  apt-get -qq -y install zabbix-proxy-sqlite3 zabbix-agent zabbix-sender zabbix-get && \
  mkdir -p /var/lib/sqlite && \
  chown zabbix:zabbix /var/lib/sqlite

# Copy scripts, Monit config and Zabbix config into place
COPY ./scripts/entrypoint.sh      /bin/docker-zabbix
COPY monitrc                     /etc/monit/monitrc
COPY ./zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
COPY ./zabbix/zabbix_proxy.conf  /etc/zabbix/zabbix_proxy.conf

# Fix permissions
RUN chmod 755 /bin/docker-zabbix \
    && chmod 600 /etc/monit/monitrc

# Expose ports for
# * 10051 zabbix_proxy
EXPOSE 10051

# Will run `/bin/docker run`, which instructs
# monit to start zabbix_proxy and zabbix_agentd.
ENTRYPOINT ["/bin/docker-zabbix"]
CMD ["run"]
