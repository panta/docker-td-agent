FROM debian:jessie
MAINTAINER Marco Pantaleoni <marco.pantaleoni@gmail.com>

# environment
ENV DEBIAN_FRONTEND noninteractive

# update
RUN apt-get update

# ruby related packages for td-agent
RUN apt-get -y --no-install-recommends install sudo curl libcurl4-openssl-dev ruby ruby-dev make

RUN apt-get -q clean

# install fluentd td-agent
RUN curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh

# clean cache files
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# install fluentd plugins
RUN /opt/td-agent/embedded/bin/fluent-gem install --no-ri --no-rdoc \
    fluent-plugin-elasticsearch \
    fluent-plugin-record-modifier \
    fluent-plugin-exclude-filter


# add conf
ADD ./etc/td-agent /etc/td-agent
ADD ./etc/security/limits.conf /etc/security/limits.conf
ADD ./etc/sysctl.d/90-fluentd.conf /etc/sysctl.d/90-fluentd.conf

CMD /etc/init.d/td-agent stop && /opt/td-agent/embedded/bin/fluentd -c /etc/td-agent/td-agent.conf
