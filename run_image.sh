#!/bin/bash

#####
# Make sure that Artifactory is running.
#
EXITED_ARTIFACTORY_COUNT=$(docker ps --filter=status=exited -a | grep artifactory | wc -l)
if [ "$EXITED_ARTIFACTORY_COUNT" != "0" ]
then
  echo "Removing Old Artifactory"
  docker ps --filter=status=exited -a -q | xargs docker rm
fi

ARTIFACTORY_COUNT=$(docker ps --filter=status=running | grep artifactory | wc -l)
if [ "${ARTIFACTORY_COUNT}" != "1" ]
then
  echo "Starting Artifactory"
  docker run --name "artifactorydata" -v /opt/artifactory/data -v /opt/artifactory/logs tianon/true
  docker run -d -p 8081:8081 --name "artifactory" --volumes-from artifactorydata  codingtony/artifactory
fi

IMAGEID=$(docker ps -a |grep "accumulo.build" | awk '{print $1}')
if [ "$IMAGEID" != "" ]
then
  echo "Stopping accumulo.build image" 
  IMAGEID=$(sudo DOCKER_HOST=$DOCKER_HOST docker stop $IMAGEID | xargs docker rm)
fi

sudo DOCKER_HOST=$DOCKER_HOST \
  docker run \
    --link artifactory:artifactory \
    -i \
    -t medined/accumulo.build \
    /bin/bash
