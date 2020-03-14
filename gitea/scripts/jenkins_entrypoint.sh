#!/usr/bin/env bash
set -eo pipefail

# Move SSH Certificate to VOLUME (volume only available at runtime)
mkdir -p /var/jenkins_home/.ssh
cp /usr/share/jenkins/ref/.ssh/id_rsa* /var/jenkins_home/.ssh
chmod 600 /var/jenkins_home/.ssh/id_rsa
chmod 644 /var/jenkins_home/.ssh/id_rsa.pub

# Non-privileged access to Docker-on-Docker
DOCKER_SOCKET=/var/run/docker.sock
[[ -S /var/run/docker.sock ]] && sudo /bin/chgrp jenkins $DOCKER_SOCKET

exec "$@"