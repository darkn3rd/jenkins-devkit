FROM jenkins/jenkins:lts

USER root
####### INSTALL DOCKER CLI
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    gnupg2 \
    software-properties-common \
    jq; \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
  add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable"; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    docker-ce-cli \
    containerd.io; \
  rm -rf /var/lib/apt/lists/*;

USER jenkins
###### GENERATE SSH KEY PAIR
RUN mkdir -p /usr/share/jenkins/ref/.ssh && \
  chmod 700 /usr/share/jenkins/ref/.ssh && \
  ssh-keygen -t rsa -b 4096 -C "testuser@example.com" -f /usr/share/jenkins/ref/.ssh/id_rsa -q -N ""
###### COPY ENTRY POINT THAT SUPPORTS SSH
COPY ./scripts/jenkins_entrypoint.sh /usr/local/bin/jenkins_entrypoint.sh
ENTRYPOINT /usr/local/bin/jenkins_entrypoint.sh

####### INSTALL PLUGINS
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
####### DISABLE SETUP WIZARD
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state; \
  echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

####### CONFIGURE JENKINS AND PLUGINS
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs
RUN mkdir -p /var/jenkins_home/casc_configs
COPY jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml
