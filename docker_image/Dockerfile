FROM openjdk:8-buster

RUN apt-get update && \
	apt-get upgrade -yy

RUN apt-get install -yy \
	tmux

RUN mkdir -p /mc-files

ADD mcrcon-0.7.1-linux-x86-64.tar.gz /mc-files
COPY start-server.sh /mc-files
RUN chmod 755 /mc-files/start-server.sh

EXPOSE 25565/tcp
EXPOSE 25565/udp

ENTRYPOINT ["/mc-files/start-server.sh"]
