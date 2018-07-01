VERSION := 0.2.0
DOCKER_COMMAND := docker run -ti --rm --privileged --network host -e EXPORTS_IP_CLASS="192.168.0.0/24" -e MASTER="192.168.0.100" -v $$(pwd)/config:/etc/lizardfs -v $$(pwd)/data:/var/lib/lizardfs darxkies/lizardfs:$(VERSION)

master: build
	$(DOCKER_COMMAND) master

metalogger: build
	$(DOCKER_COMMAND) metalogger

chunkserver: build
	$(DOCKER_COMMAND) chunkserver

cgiserver: build
	$(DOCKER_COMMAND) cgiserver

shell: build
	$(DOCKER_COMMAND) shell

docker-compose: build
	docker-compose -f docker-compose.yml up

build:
	docker build -t darxkies/lizardfs:$(VERSION) docker

publish: build
	docker push darxkies/lizardfs:$(VERSION) 
