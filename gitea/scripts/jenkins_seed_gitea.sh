#!/usr/bin/env bash

###### SPIN UNTIL SERVICE IS UP
# This creates git repo accounts and install ssh pub key into gitea user account
/usr/local/bin/wait-for-it.sh gitea:3000 --strict -- echo "Seeding Gitea Server"
/usr/local/bin/gitea_user_repos.sh gitea testuser /var/jenkins_home/.ssh/id_rsa.pub

exec "$@"