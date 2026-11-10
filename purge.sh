#!/bin/bash
set -x
docker container prune -f
docker network prune -f
docker volume prune -f
