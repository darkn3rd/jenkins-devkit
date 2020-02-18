# Jenkins Docker-On-Docker Kit

The purpose of this is to create a Docker-On-Docker Jenkins environment with BlueOcean plugins.  Unlike the `jenkinsci/blueocean` docker image, this one does not compile BlueOcean plugins from source to use within a container, but rather fetches the plugins from [Jenkins Plugins Index](https://plugins.jenkins.io/), which is an online public artifact repository for Jenkins plug-ins.

## Docker-On-Docker

> Why?  

This is considering an anti-pattern, and SHOULD NEVER be used online, because of the inherit security risk of allowing a container to access a service running on root.  This is DANGEROUS.

For a small local development environment, where you need a Jenkins server that builds and pushes Docker image, this is an easy way to do this.  So for this niche use case, it is not unreasonable to do this.

You need to install Docker inside the Jenkins Docker container because you will need to, well, build docker images and push them using a Jenkins docker image.  Thus docker-on-docker.


## Notes

### Minimal Plugins

I have been referencing the numerous plug-ins, and there are many to determine the minimal set required. There's a lot.  There are some dependencies that are not installed, but absolutely required.

* Pipelines
  * `durable-tasks` - required as pipelines will call a shell script produced from this plugin.

There are a group of plugins called `pipeline` and another group called `workflow`, but are part of pipelines, so I included all the ones installed by default recommended through the Plugin wizard.
