#! /bin/bash

docker build . -t andreatp/custom-keycloak:18.0.0
docker push docker.io/andreatp/custom-keycloak:18.0.0
