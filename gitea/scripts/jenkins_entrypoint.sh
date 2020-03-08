#!/usr/bin/env bash

# Move SSH Certificate to VOLUME (volume only available at runtime)
mkdir -p /var/jenkins_home/.ssh
mv /usr/share/jenkins/ref/.ssh/id_rsa* /var/jenkins_home/.ssh
chmod 600 /var/jenkins_home/.ssh/id_rsa
chmod 644 /var/jenkins_home/.ssh/id_rsa.pub

# Non-privileged access to Docker-on-Docker
DOCKER_SOCKET=/var/run/docker.sock
[[ -S /var/run/docker.sock ]] && chgrp jenkins $DOCKER_SOCKET

echo "start JENKINS"
# if 'docker run' first argument start with '--' the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  chown -R jenkins:jenkins /var/jenkins_home/
  su - jenkins -c "exec  /sbin/tini -- /usr/local/bin/jenkins.sh \"$@\""
fi

exec "$@"