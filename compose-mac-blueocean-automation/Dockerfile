FROM jenkinsci/blueocean:latest

USER jenkins
####### INSTALL PLUGINS
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
####### DISABLE SETUP WIZARD
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state; \
  echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion
####### CONFIGURE JENKINS AND PLUGINS
ENV CASC_JENKINS_CONFIG /config/jenkins.yaml
COPY jenkins.yaml $CASC_JENKINS_CONFIG
