FROM debian:jessie
MAINTAINER Marco Pantaleoni <marco.pantaleoni@gmail.com>

# environment
ENV DEBIAN_FRONTEND noninteractive

# update
RUN apt-get update

# ruby related packages for td-agent
RUN apt-get -y --no-install-recommends install sudo curl libcurl4-openssl-dev ruby ruby-dev make
RUN apt-get -y --no-install-recommends install gcc sqlite3 libsqlite3-dev libmysqlclient-dev

RUN apt-get -q clean

# install fluentd td-agent
RUN curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh

# clean cache files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# install gems needed by fluentd plugins
RUN gem install sqlite3
RUN gem install mysql2

# install fluentd plugins
RUN /opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc \
    fluent-plugin-elasticsearch \
    fluent-plugin-record-modifier \
    fluent-plugin-exclude-filter \
    fluent-plugin-sqlite3 \
    fluent-plugin-sql

# cleanup
RUN apt-get -y remove gcc
RUN apt-get -y -q autoremove
RUN apt-get -q clean

# add conf
ADD ./etc/td-agent /etc/td-agent
ADD ./etc/security/limits.conf /etc/security/limits.conf
ADD ./etc/sysctl.d/90-fluentd.conf /etc/sysctl.d/90-fluentd.conf

CMD /etc/init.d/td-agent stop && /opt/td-agent/embedded/bin/fluentd -c /etc/td-agent/td-agent.conf
