# Jenkins Docker-On-Docker Kit

This brings up a local Jenkins dev environ for experimenting with automation with Jenkins.  Automation can include scripts, jobs, pipelines, and configuration on the Jenkins platform.

This setup uses the `jenkins/jenkins` docker image and installs the needed plugins from the online public artifact repository for Jenkins plug-ins: [Jenkins Plugins Index](https://plugins.jenkins.io/), and then the docker client so that docker images can be built and pushed into a docker repository.
