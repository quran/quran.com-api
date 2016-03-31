Before you begin
----------------
You must note that while we would like to be eager with upgrading to the latest Rails version, our biggest contingency is compositive-primary-keys gem which is playing catch up with the Rails versions especially that every new update does something to ActiveRecord and breaks CPK! So make sure CPK is happy with the Rails version first before jumping.

#### Requirements
- Rails 4+
- Elasticsearch
- Redis

#### Installations
Gems:
```
bundle install
```

Elasticsearch:
See config/elasticsearch/README.md

Redis:
```
brew install redis
```

Postgresql:

This is the best way if you're on mac: http://postgresapp.com/
But to install the pg gem, you will have to do:
```
gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config
```

If you decide to install postgres with homebrew (`brew install postgresql`) you should not have this problem.

Why should you use the app? You have quick commandline tools such as:
The following tools come with Postgres.app:

PostgreSQL: clusterdb createdb createlang createuser dropdb droplang dropuser ecpg initdb oid2name pg_archivecleanup pg_basebackup pg_config pg_controldata pg_ctl pg_dump pg_dumpall pg_receivexlog pg_resetxlog pg_restore pg_standby pg_test_fsync pg_test_timing pg_upgrade pgbench postgres postmaster psql reindexdb vacuumdb vacuumlo

See: http://postgresapp.com/documentation/cli-tools.html


Database
--------

Currently, not everyone has access to the database as it's not opensource and will require you to contact one of the project's collaborators for access. Once you have access, you can pull down the submodule in one of two ways:
```
git clone --recursive git@github.com:quran/quran-api-rails.git
cd quran-api-rails
```
For already cloned repo:
```
git clone git@github.com:quran/quran-api-rails.git
cd quran-api-rails
git submodule update --init --recursive
```


### Usage

```
http://localhost:3000/surahs/1/ayat?audio=1&content=21&from=1&quran=1&to=10
```

Redis
-------------
### To start:
```
redis-server /usr/local/etc/redis.conf
```

Tests
-------------
We have put some time to test the api and the search. You may need to have elasticsearch running in order for the tests to go through search although we should be looking for an elasticsearch mock.

Simply run:
```
rspec
```
