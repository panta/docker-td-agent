# Docker td-agent

Docker image with:

- [td-agent](http://www.fluentd.org/)
- fluent-plugin-elasticsearch
- fluent-plugin-record-modifier
- fluent-plugin-exclude-filter

which do nothing by default.

Fluentd config is `/etc/td-agent/td-agent.conf` could be easily override by volume.

`-v /path/to/fluentdconfdir:/etc/td-agent`


# Simple usage

`docker run -d -v /path/to/td-agent:/etc/td-agent panta/td-agent`

# settings

PATH

- `/etc/td-agent/td-agent.conf`: td-agent config file
- `/var/log/td-agent/`: td-agent log directory

default td-agent.conf

- see: [td-agent.conf](https://github.com/panta/docker-td-agent/blob/master/etc/td-agent/td-agent.conf)

