FROM ubuntu:18.04

MAINTAINER Darx Kies <darxkies@gmail.com>

RUN apt-get -y update && apt-get -y install rsyslog lizardfs-master lizardfs-metalogger lizardfs-chunkserver lizardfs-cgiserv lizardfs-adm lizardfs-client man && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD files/rsyslogd-stdout.conf /etc/rsyslog.d/
ADD files/docker-entrypoint.sh /

EXPOSE 9419 9420 9421 9422 9425

VOLUME [ "/etc/lizardfs", "/var/lib/lizardfs" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "master" ]
