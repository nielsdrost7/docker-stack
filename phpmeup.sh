#!/bin/bash
# shellcheck disable=SC2046
docker exec -it --user=crater $(docker ps -aqf "name=app") bash
