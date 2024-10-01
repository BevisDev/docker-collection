# Welcome to ELK Stack on Docker

[![Elastic Stack version](https://img.shields.io/badge/Elastic%20Stack-8.15.0-00bfb3?style=flat&logo=elastic-stack)](https://www.elastic.co/blog/category/releases)

It gives you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticsearch and the visualization power of Kibana.

### Requirements

- Docker Engine

### Run resources

```sh
docker compose up -d
```

By default, the stack exposes the following ports:

- 5044 || 9600 : Logstash
- 9200 || 9300 : Elasticsearch
- 5601 : Kibana

### Troubleshooting Virtual Memory misconfigurations

```text
{ ... "message": "... max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]" }
```

### Solution:

- Temporarily: the setting will only last for the duration of the session.
  If the host reboots, the setting will be reset to the original value.

```shell
sysctl -w vm.max_map_count=262144
```

- Permanently: insert the new entry into the `/etc/sysctl.conf` file with the required parameter:

```
vm.max_map_count = 262144`
```
