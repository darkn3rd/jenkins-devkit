FROM jenkins/jenkins:lts

USER root
####### INSTALL DOCKER CLI
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    gnupg2 \
    software-properties-common \
    jq \
    sudo; \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
  add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable"; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    docker-ce-cli \
    containerd.io; \
  rm -rf /var/lib/apt/lists/*; \
  echo "jenkins ALL=(root) NOPASSWD:/bin/chgrp jenkins /var/run/docker.sock" > /etc/sudoers.d/jenkins

USER jenkins
###### GENERATE SSH KEY PAIR
RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
  chmod 700 /usr/share/jenkins/ref/.ssh && \
  ssh-keygen -t rsa -b 4096 -C "jenkins@example.com" -f /usr/share/jenkins/ref/.ssh/id_rsa -q -N ""

####### INSTALL PLUGINS
COPY ./scripts/jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

####### DISABLE SETUP WIZARD
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state; \
  echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

####### CONFIGURE JENKINS AND PLUGINS
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs
RUN mkdir -p /var/jenkins_home/casc_configs
COPY ./scripts/jenkins/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

###### COPY ENTRY POINT THAT SUPPORTS SSH
COPY ./scripts/jenkins/jenkins-entrypoint.sh /usr/local/bin/jenkins-entrypoint.sh
ENTRYPOINT ["jenkins-entrypoint.sh"]
CMD ["/sbin/tini","-g", "--", "/usr/local/bin/jenkins.sh"]
