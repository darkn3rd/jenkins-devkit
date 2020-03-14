docker-compose stop
docker-compose rm --force

docker volume ls --quiet --filter name=${PWD}_ | xargs docker volume rm
docker network ls --filter name=compose -q | xargs docker network rm
docker rmi ci-devkit/dond --force