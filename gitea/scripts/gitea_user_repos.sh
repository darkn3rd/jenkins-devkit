#!/usr/bin/env bash
# This script populates example repositories on gitea
# Requirements
# - SSH public key that is used by CI server
# - Gitea running on $GITEA_HOST 
# - Existing user created on Gitea server
# - Public git repos of webmf-ruby-sinatra and webmf-python-flask

# Variables used in script
GITEA_HOST=${1:-"localhost"}
GITEA_USER=${2:-"testuser"}
SSH_KEY_PATH=${3:-"$HOME/.ssh/id_rsa.pub"}
REPOS=(
  https://github.com/darkn3rd/webmf-ruby-sinatra
  https://github.com/darkn3rd/webmf-python-flask
)

echo "DEBUG: GITEA_HOST=$GITEA_HOST"
echo "DEBUG: GITEA_USER=$GITEA_USER"
echo "DEBUG: SSH_KEY_PATH=$SSH_KEY_PATH"


###### GENERATE USER TOKEN ###### 
GITEA_USER_TOKEN=$(curl --silent \
   --user testuser:testuser \
   --request POST "http://$GITEA_HOST:3000/api/v1/users/$GITEA_USER/tokens" \
   --header "accept: application/json" \
   --header "Content-Type: application/json" \
   --data "{ \"name\": \"$GITEA_USER\"}" | jq -r '.sha1'
)

###### GENERATE SSH PUB KEY ######
cat <<-KEY > key.json
{
  "read_only": false,
  "title": "$(cat $SSH_KEY_PATH | awk '{print $NF}')",
  "key": "$(cat $SSH_KEY_PATH/.ssh/id_rsa.pub)"
}
KEY

curl  --silent \
 --request POST "http://$GITEA_HOST:3000/api/v1/user/keys?access_token=$GITEA_USER_TOKEN" \
 --header "content-type: application/json" \
 --data @./key.json


###### CREATE EMPTY REPOS ###### 
cat <<-REPO > repo.json
{
  "auto_init": false,
  "description": "Sinatra CI Example",
  "name": "sintra-example",
  "private": true
}
REPO

curl  --silent \
 --request POST "http://$GITEA_HOST:3000/api/v1/user/repos?access_token=$GITEA_USER_TOKEN" \
 --header "accept: application/json" \
 --header "content-type: application/json" \
 --data @./repo.json

cat <<-REPO > repo.json
{
  "auto_init": false,
  "description": "Flask CI Example",
  "name": "flask-example",
  "private": true
}
REPO

curl  --silent \
 --request POST "http://$GITEA_HOST:3000/api/v1/user/repos?access_token=$GITEA_USER_TOKEN" \
 --header "accept: application/json" \
 --header "content-type: application/json" \
 --data @./repo.json

### POPULATE EMPTY REPOSITORIES
for REPO in ${REPOS[@]}; do
  git clone $REPO
  pushd ${REPO##*/}
  git remote rename origin upstream
  git remote add origin git@$GITEA_HOST:testuser/${REPO##*-}-example.git
  git push -u origin master
  popd
  # CLEANUP
  rm -rf ${REPO##*/}
done

# CLEANUP
rm key.json
rm repo.json
