#!/usr/bin/env bash

###### RUN SEED SCRIPT IN BACKGROUND)
/usr/local/bin/gitea_accounts.sh &

exec "$@"