#!/usr/bin/env bash

create_accounts()
{
  ######  CREATE ACCOUNTS ###### 
  gitea admin create-user \
    --name adminuser \
    --password adminuser \
    --admin \
    --email admin@example.com \
    --must-change-password "false" || true

  gitea admin create-user \
    --name jenkins \
    --password jenkins  \
    --email jenkins@example.com \
    --must-change-password "false" || true
}

###### SPIN UNTIL SERVICE IS UP
/usr/local/bin/wait-for-it.sh localhost:3000 -- echo "Creating accounts..."
create_accounts


