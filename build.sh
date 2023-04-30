#!/bin/bash

#sudo DOCKER_BUILDKIT=1 docker build . -t whisper-local
#sudo DOCKER_BUILDKIT=1 docker compose build ###

sudo docker compose build
#sudo docker compose up -d

# sudo docker run --name whisper-local -it --rm whisper-local

