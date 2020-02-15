# Compose (macOS version)

This brings up a small Jenkins Pipeline DevKit using Docker-Compose on macOS using Docker-Desktop or Linux with the Docker CE installed.

This will NOT work on Windows as Unix sockets is not supported on Windows.

## General Instructions


### Step 1: Create environment

```bash
docker-compose up -d
# copy initial password to clipboard
pbcopy < ./jenkins_data/secrets/initialAdminPassword
```

### Step 2: Initial Setup

For *local* dev environments, I typically do `testuser` for user and password.

I typically choose the recommend plugins and go from there.

### Step 2: Create Jobs

Create new item, and chose something like tasks or pipelines.

## Tips

### Extracting List of Plugins

If your user name and password are `testuser`, you can do this:

```bash
# function to get list of plugins
freeze_plugins() {
  JENKINS_USER=$1
  JENKINS_PSSWD=$2
  JENKINS_HOSTNAME=${3:-'localhost'}
  JENKINS_PORT=${4:-'8080'}

  if [[ $# -lt 2 ]] ; then
    echo "Usage: $0 <jenkins_user> <jenkins_psswd> [jenkins_hostname] [jenkins_port]"
    return 1
  fi

  JENKINS_HOST="${JENKINS_USER}:${JENKINS_PSSWD}@${JENKINS_HOSTNAME}:${JENKINS_PORT}"
  JENKINS_PARAMS="depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins"
  JENKINS_URL="http://${JENKINS_HOST}/pluginManager/api/xml?${JENKINS_PARAMS}"
  PERL_REGEX='s/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'

  curl -sSL "${JENKINS_URL}" | perl -pe "${PERL_REGEX}" | sed 's/ /:/'
}

# get list of plugins and save to plugins.txt
freeze_plugins testuser testuser > plugins.txt
```

## Notes

### Deprecation Notice on DockerHub

This underlying image `jenkinsci/blueocean` is supposedly deprecated in favor of `jenkins/jenkins`, but the later will not work with this project or all of the wonderful BlueOcean tutorials.  

This is because `docker` is not supported inside the image `jenkins/jenkins`.

* [GitHub `blueocean-plugin`](https://github.com/jenkinsci/blueocean-plugin) source code for `jenkinsci/blueocean` docker image
* [Blue Ocean Docs/Tutorials](https://jenkins.io/doc/book/blueocean/)
* [DockerHub `jenkinsci`](https://hub.docker.com/u/jenkinsci) organization
* [`jenkins/jenkins`](https://hub.docker.com/r/jenkins/jenkins) Docker Image
