# CI DevKit with Gitea + Jenkins

This is a small CI DevKit with Jenknins and Gitea.


## Setup

```bash
cat <<-COMPOSE_ENV > .env
USER_GID=$(id -g) 
USER_UID=$(id -u)
COMPOSE_ENV
```

## Startup 

```bash
docker-compose build
docker-compose up -d
```

## Seed Repositories on Gitea

```bash
docker exec -t ci-devkit-jenkins gitea_user_repos.sh
```

## Clean 

```bash
# Stop Containers
docker-compose stop
docker-compose rm --force

# Remove Images
docker rmi ci-devkit/dond --force

# Remove Volumes
docker volume ls --quiet --filter name=${PWD##*/}_ | xargs docker volume rm
rm -rf ./gitea

# Remove Associated Networks
docker network ls --filter name=compose -q | xargs docker network rm
```