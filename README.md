# Kafka

[![Gitter](https://img.shields.io/gitter/room/vasyl-purchel/kafka.svg)](https://gitter.im/vasyl-purchel/kafka)
[![imagelayers.io](https://badge.imagelayers.io/vasylpurchel/kafka:latest.svg)](https://imagelayers.io/?images=vasylpurchel/kafka:latest)
[![Docker Stars](https://img.shields.io/docker/stars/vasylpurchel/kafka.svg)](https://hub.docker.com/r/vasylpurchel/kafka/)
[![Docker Pulls](https://img.shields.io/docker/pulls/vasylpurchel/kafka.svg)](https://hub.docker.com/r/vasylpurchel/kafka)

This is an image for [apache kafka][1] based on [ubuntu:trusty docker image][2]

## Supported tags and respective Dockerfile links:

 * 0.9.0, latest, circleci ([Dockerfile][3])

latest may be broken as it is not checked by CircleCI as it is built by docker hub,
circleci tag is pushed only after build and verification passed on CircleCI,
0.9.0 tag is marking that kafka version is 0.9.0

## Usage

The container has default environment variables that shouldn't be touched:

| Environment Variable | Description | Value |
| -------------------- | ----------- | ----- |
| ```KAFKA_HOME``` | home directory where kafka is installed | ```/opt/kafka/``` |
| ```KAFKA_CONFIG_FILE``` | configuration file for zookeeper | ```/opt/kafka/config/server.properties``` |

To run the container:

```bash
docker run -d -ti -e KAFKA_HEAP_OPTS="-Xmx64M -Xms64M" -e KAFKA_BROKER_ID=1 -e KAFKA_ZOOKEEPER_CONNECT="172.17.0.1:2181,172.17.0.1:2182,172.17.0.1:2183" -e KAFKA_ADVERTISED_PORT=9092 -e KAFKA_ADVERTISED_HOST_NAME="172.17.0.1" --publish 9092:9092 --name kafka-node-1 -v /data/kafka/node1:/tmp/kafka-logs vasylpurchel/kafka
```

To configure kafka instance you can use environment variables that starts with a same name as kafka configuration entries with ```KAFKA_``` prefix, uppercase and words splitted by ```_``` instead of ```.```

Few examples:

| Environment Variable | Zookeeper Property |
| -------------------- | ------------------ |
| ```KAFKA_ZOOKEEPER_CONNECT``` | ```zookeeper.connect``` |
| ```KAFKA_LOG_DIRS``` | ```log.dirs``` |
| ```KAFKA_ADVERTISED_HOST_NAME``` | ```advertised.host.name``` |

By default in server.properties file default values are:

| Kafka Property | Value |
| -------------- | ----- |
| ```broker.id``` | ```0``` |
| ```listeners``` | ```PLAINTEXT://:9092``` |
| ```num.network.threads``` | ```3``` |
| ```num.io.threads``` | ```8``` |
| ```socket.send.buffer.bytes``` | ```102400``` |
| ```socket.receive.buffer.bytes``` | ```102400``` |
| ```socket.request.max.bytes``` | ```104857600``` |
| ```log.dirs``` | ```/tmp/kafka-logs``` |
| ```num.partitions``` | ```1``` |
| ```num.recovery.threads.per.data.dir``` | ```1``` |
| ```log.retention.hours``` | ```168``` |
| ```log.segment.bytes``` | ```1073741824``` |
| ```log.retention.check.interval.ms``` | ```300000``` |
| ```log.cleaner.enable``` | ```false``` |
| ```zookeeper.connect``` | ```localhost:2181``` |
| ```zookeeper.connection.timeout.ms``` | ```6000``` |

To save data you need to mount volume to ```KAFKA_LOG_DIRS```

docker-entry-point.sh is generating configuration for container and runs any parameters after,
so you can use this image to run other kafka related tasks and not only starting server with server.properties config(default one)

## Notes

Make sure you are in kafka folder and that ip address in **docker-compose.yml** file is correct (mine is 127.17.0.1):

```bash
ifconfig | grep "docker0" -C 2 | grep "inet addr"
```

build image:

```bash
docker build -t vasylpurchel/kafka .
```

run 3 nodes from docker-compose:

```bash
docker-compose up
```

check that it works just run:

```bash
docker run -d -ti vasylpurchel/kafka kafka-topics.sh --create --zookeeper 172.17.0.1:2181,172.17.0.1:2182,172.17.0.1:2183 --replication-factor 2 --partitions 3 --topic test
```

## TODO

 * Add badges for image size, layers, docker starts and pulls, circleCI and maybe something else

[1]: http://kafka.apache.org/
[2]: https://hub.docker.com/_/ubuntu/
[3]: https://github.com/vasyl-purchel/kafka-docker/blob/master/Dockerfile
