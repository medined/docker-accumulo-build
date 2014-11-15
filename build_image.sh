#!/bin/bash
sudo DOCKER_HOST=$DOCKER_HOST docker build --no-cache --rm=true -t medined/accumulo.build .
