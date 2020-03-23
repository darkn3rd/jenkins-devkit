#!/usr/bin/env bash

main() {
  # delay until service is up
  /usr/local/bin/wait-for-it.sh localhost:3000 -- echo "Creating accounts..."
  # create admin user
  create_demo_account adminuser adminuser true
  # create non-admin user
  create_demo_account testuser testuser 
}

create_demo_account() {
  USERNAME=$1
  PASSWORD=$2
  IS_ADMIN=$3

  [[ -z $USERNAME ]] && return 1
  [[ -z $PASSWORD ]] && return 1

  OPTIONS="--name $USERNAME --password $PASSWORD"
  [[ -z $IS_ADMIN ]] || OPTIONS=" $OPTIONS --admin"
  OPTIONS=" $OPTIONS --email $USERNAME@example.com --must-change-password=false"

  gitea admin create-user $OPTIONS || true
}

main