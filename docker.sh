#!/bin/bash
#Keepwalking86
#Build docker image and run container for ...

DOCKER_IMAGE=keepwalking/lemp-laravel5
DOCKER_CONTAINER=lemp-laravel5
PORTS=$(netstat -nta |grep -i listen |awk -F " " '{print $4}' |grep ":8081$\|:27018$\|:9099$" |awk -F":" '{print $NF}')

#Check image exists and build image
sudo docker images | grep $DOCKER_IMAGE &>/dev/null
if [[ $? -ne 0 ]]; then
	docker build -t ${DOCKER_IMAGE} .
else
	echo "Docker image $DOCKER_IMAGE is existing"
fi
#Check container exists and run container
docker ps -a | awk '{print $NF}' |grep $DOCKER_CONTAINER &>/dev/null
if [[ $? -eq 0 ]]; then
	echo "$DOCKER_CONTAINER container is existing"
	exit 0;
else
	#Check port exists
	netstat -nta |grep -i listen |awk -F " " '{print $4}' |grep ":8081$\|:27018$\|:9099$" &>/dev/null
	if [[ $? -eq 0 ]]; then
		echo -n $PORTS; echo " ports are existing. Please, use other ports"
		exit 0;
	else
	 	echo "Running docker container"
		sleep 2
		docker run -d -p 8081:80 -p 27018:27017 -p 9099:9000 -v `pwd`/mongo:/data/db -v `pwd`/app:/var/www/example --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
	fi
fi
