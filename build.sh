#!/bin/bash
set -e
environment=${RAILS_ENV:-development}
artifacts=build-cache/$environment/bundle
[ -d $artifacts ] || mkdir -p $artifacts
touch $artifacts/blank
if [ "$environment" == "development" ]; then
  docker-compose build #--no-cache
  ./save-artifacts.sh $artifacts
else
  docker-compose -f docker-compose.$environment.yml build
fi
