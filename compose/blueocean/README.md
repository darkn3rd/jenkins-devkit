# Jenkins DevKit with BlueOcean (macOS/Linux version w/o automation)

This brings up a local Jenkins dev environ for experimenting with automation with Jenkins.  Automation can include scripts, jobs, pipelines, and configuration on the Jenkins platform.

This particular setup does not include any automation, so the steps are applied manually.  This uses the [`jenkinsci/blueocean`](https://hub.docker.com/r/jenkinsci/blueocean), which reguarly updated from [blueocean project](https://github.com/jenkinsci/blueocean-plugin) despite any misinformation about deprecation.

## General Instructions

### Step 1: Create environment

```bash
docker-compose up -d
# copy initial password to clipboard
pbcopy < ./jenkins_data/secrets/initialAdminPassword
```

### Step 2: Select Install Suggested Plugins

A wizard has options, in this select the `Install Suggested Plugins` to keep thins simple.

### Step 3: Create a User

For *local* dev environments, I typically do `testuser` for user and password.

### Step 4: Instance configuration

The defaults of localhost:8080 is fine for our purposes.

### Step 2: Create Jobs

Create new item, and chose something like tasks or pipelines.

## Tips

### Extracting List of Plugins

You can use the function below to get the list of plugins.

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
JENKINS_USER='admin'
JENKINS_PSWD=$(cat /jenkins_data/secrets/initialAdminPassword)
freeze_plugins admin $(cat /jenkins_data/secrets/initialAdminPassword) | sort > plugins.txt

# list plugins w/o versions (use latest)
cat plugins.txt | cut -d: -f1 > plugins_without_verions.txt
```

## Links

* [GitHub `blueocean-plugin`](https://github.com/jenkinsci/blueocean-plugin) source code for `jenkinsci/blueocean` docker image
* [Blue Ocean Docs/Tutorials](https://jenkins.io/doc/book/blueocean/)
* [DockerHub `jenkinsci`](https://hub.docker.com/u/jenkinsci) organization
* [`jenkins/jenkins`](https://hub.docker.com/r/jenkins/jenkins) Docker Image
