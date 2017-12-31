# quran-api on docker 

## Development

build the image:

To build the image in development:

    ./build.sh

This invokes `docker-compose build` then saves build artificats.
Subsequent builds are much faster because gems are cached.
It also copies back `Gemfile.lock` so that it is properly checked in git.

run it:

    docker-compose up

Note that by default `docker-compose.yml` and `docker-compose.override.yml` will be merged
and loaded. The latter sets the environment for development and builds the ruby image.
It also mounts `.` to `/app` inside the container so that any code changes on the host are
reflected in realtime inside the container. There is no need to rebuild the image
unless any of `Gemfile` or `Gemfile.lock` are updated.

Note also that `DATABASE_URL` and `ELASTICSEARCH_HOST` determines the database and
elasticsearch connection parameters. `postgres` and `elasticsearch` services determine
how to run those. If you have the images ready, then you are good to go.
Otherwise, you have to go to respective repos and build them. Alternatively,
modify `docker-compose.override.yml` to include build instructions.

## Production

To rebuild the image for production:

    RAILS_ENV=production ./build.sh    

Then tag and push the resulting image to a registry so that a `docker stack deploy` finds it.
