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
docker-compoose build
docker-compose up -d
```


## Clean 

```bash
# Stop Containers
docker-compose stop
docker-compose rm --force

# Remove Images
docker rmi ci-devkit/dond --force

# Remove Resources
docker volume ls --quiet --filter name=${PWD}_ | xargs docker volume rm
docker network ls --filter name=compose -q | xargs docker network rm
```