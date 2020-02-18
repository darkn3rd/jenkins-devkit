FROM jenkins/jenkins:lts

# Install Docker
USER root
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		gnupg2 \
    software-properties-common; \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
  add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable"; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    docker-ce-cli \
    containerd.io; \
  rm -rf /var/lib/apt/lists/*

# Install Jenkins Plugins
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# install plugins list
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# remove initial wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# docker-ce \
# docker-ce-cli \
# containerd.io; \
