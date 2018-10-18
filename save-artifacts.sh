#!/bin/bash
set -e
artifacts="$1"
if [ -z "$artifacts" ]; then
  echo "USAGE: $0 <cache-dir>"
  exit 1
fi

docker run -i -v ${PWD}/${artifacts}:/artifacts qurancomapi_api:dev-latest /bin/bash << COMMANDS
echo "Syncing artifacts back to host, it might take time if this is the first time..."
rsync -av /app/Gemfile.lock /artifacts/Gemfile.lock
rsync -az /usr/local/bundle/ /artifacts/
COMMANDS

echo "Copying Gemfile.lock back to host..."
mv -v $artifacts/Gemfile.lock .
