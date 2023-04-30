# syntax=docker/dockerfile:1

# Run with DOCKER_BUILDKIT=1 # BUILDKIT_PROGRESS=plain

#  Test the result:
# echo UklGRiQAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQAAAAA= | base64 -d | docker run -i --rm --name whisper whisper whisper --language=English --model=tiny.en -
#  Enter a running container:
# docker exec -it whisper bash
#  Process a file:
# cat a.aac | sudo docker run -i --rm --name whisper whisper whisper --language=English --model=tiny.en -

# TODO: use ggerganov/whisper.cpp

FROM scratch
RUN <<EOF :
ERROR-----Must-run-with-----DOCKER_BUILDKIT=1
EOF

# https://github.com/jlonge4/whisperAI-flask-docker/blob/main/whisperapp/Dockerfile
# https://github.com/openai/whisper

FROM ubuntu AS build_whisper
SHELL ["/bin/bash", "-c"]

# Install packages
RUN <<_END
# Install packages
set -uexo pipefail
apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  python3.9 ffmpeg python3-pip \
  ;
rm -rf /var/lib/apt/lists/*
_END

# Install whisper
RUN <<_END
# Install whisper
set -uexo pipefail
#pip3 install -U numpy
pip3 install -U openai-whisper
_END

# Download models
RUN <<_END
# Download models
set -uexo pipefail
mkdir -p ~/.cache/whisper
cd ~/.cache/whisper
wget -c --progress=bar:force $(egrep -o 'https://.*\.pt' "$(dirname $(find / -name transcribe.py | head -1))/__init__.py" | perl -nE 'print if !$f{$_}; $f{$_}=1;')
#/usr/local/bin/whisper - --model tiny.en
#/usr/local/bin/whisper - --model tiny
#/usr/local/bin/whisper - --model base.en
#/usr/local/bin/whisper - --model base
#/usr/local/bin/whisper - --model small.en
#/usr/local/bin/whisper - --model small
#/usr/local/bin/whisper - --model medium.en
#/usr/local/bin/whisper - --model medium
#/usr/local/bin/whisper - --model large
_END

FROM build_whisper AS whisper

CMD ["/bin/bash", "-c", "while true; do sleep 99999; done"]
#ENTRYPOINT ["/start.sh"]
#HEALTHCHECK CMD /healthcheck.sh

