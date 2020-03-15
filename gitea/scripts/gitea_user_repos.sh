#!/usr/bin/env bash
# This script populates example repositories on gitea
# Requirements
# - SSH public key that is used by CI server
# - Gitea running on $GITEA_HOST 
# - Existing user created on Gitea server
# - Public git repos of webmf-ruby-sinatra and webmf-python-flask

# Variables used in script
SSH_KEY_PATH=${1:-"$HOME/.ssh/id_rsa.pub"}
GITEA_HOST=${2:-"gitea"}
GITEA_USER=${3:-"jenkins"}
GITEA_PSWD=$GITEA_USER
GITEA_TEMP=/tmp/gitea_stage

# Repositories and Descriptions used
declare -A REPOSITORIES=( 
  [sinatra-example]=https://github.com/darkn3rd/webmf-ruby-sinatra
  [flask-example]=https://github.com/darkn3rd/webmf-python-flask
)

declare -A DESCRIPTIONS=( 
  [sinatra-example]="Sinatra CI Example"
  [flask-example]="Flask CI Example"
)

main() {
  mkdir -p $GITEA_TEMP
  GITEA_USER_TOKEN=$(create_token)
  # save token in case needed later
  echo $GITEA_USER_TOKEN > $GITEA_TEMP/token

  # with token and temp directory create repositories
  if [[ -n "$GITEA_USER_TOKEN" && -d "$GITEA_TEMP" ]]; then
    create_ssh_key
    # create and populate repositories
    for GITEA_REPO in "${!REPOSITORIES[@]}"; do
      if create_repo $GITEA_REPO "${DESCRIPTIONS[$GITEA_REPO]}"; then
        populate_repository ${REPOSITORIES[$GITEA_REPO]} $GITEA_REPO
      fi
    done
  fi

}

create_token() {
  curl --silent \
   --user $GITEA_USER:$GITEA_PSWD \
   --request POST "http://$GITEA_HOST:3000/api/v1/users/$GITEA_USER/tokens" \
   --header "accept: application/json" \
   --header "Content-Type: application/json" \
   --data "{ \"name\": \"$GITEA_USER\"}" | jq -r '.sha1'
}

create_ssh_key() {
  cat <<-KEY > $GITEA_TEMP/key.json
{
  "read_only": false,
  "title": "$(cat $SSH_KEY_PATH | awk '{print $NF}')",
  "key": "$(cat $SSH_KEY_PATH)"
}
KEY

  curl  --silent \
  --request POST "http://$GITEA_HOST:3000/api/v1/user/keys?access_token=$GITEA_USER_TOKEN" \
  --header "content-type: application/json" \
  --data "@$GITEA_TEMP/key.json"
}

create_repo() {
  REPO_NAME="$1"
  DESCRIPTION="$2"

  [[ -z $REPO_NAME ]] && return 1

  cat <<-REPO > $GITEA_TEMP/$REPO_NAME.json
{
  "auto_init": false,
  "description": "$DESCRIPTION",
  "name": "$REPO_NAME",
  "private": true
}
REPO
  curl  --silent \
    --request POST "http://$GITEA_HOST:3000/api/v1/user/repos?access_token=$GITEA_USER_TOKEN" \
    --header "accept: application/json" \
    --header "content-type: application/json" \
    --data "@$GITEA_TEMP/$REPO_NAME.json"
}

populate_repository() {
  GIT_URL=$1
  GITEA_REPO=$2

  pushd $GITEA_TEMP
  git clone $GIT_URL

  # push git repo to empty gitea repo
  pushd ${GIT_URL##*/}
  git remote rename origin upstream
  git remote add origin git@$GITEA_HOST:jenkins/$GITEA_REPO.git
  git push -u origin master
  popd
  
  # cleanup
  rm -rf ${GIT_URL##*/}
  popd
}

main
