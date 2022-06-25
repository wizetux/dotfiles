#!/bin/bash

if [ "${#}" != 1 ]; then
  echo "Usage: docker-start.sh projectname"
  exit 1
fi

projectname=${1}

if [ ! -f docker-compose.yml ]
then
  echo "No valid docker compose file found in current directory"
  exit 1
fi

# Search for container name in the docker-compose file
if [ $(grep ${projectname}: docker-compose.yml | wc -l) == 0 ]
then
  echo "This doesn't appear to be the correct project for ${projectname}" 
  exit 1
fi

docker-compose up -d && docker-compose logs -f $projectname
