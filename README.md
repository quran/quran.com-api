# Quran.com API [Join Quran.com community](https://quran-community.herokuapp.com)

[![Code Climate](https://codeclimate.com/github/quran/quran.com-api.png)](https://codeclimate.com/github/quran/quran.com-api)

#### Requirements
- Rails 5.0.1
- Elasticsearch 5.0.1
- Ruby 3.1.0

#### Installations
Gems:
```
bundle install
```

Elasticsearch:
See config/elasticsearch/README.md

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

### Database
It's private, we will not share complete dump. If you need mini version for contributing to quran.com, please join our slack channel and ask one of project's collaborator for access.

### Usage
```
http://localhost:3000/api/v4/chapters/1
```

### Documentation
https://quran.api-docs.io/v4/

Note that v3 is no longer being extended or fixed. For v3 -> v4 migration guide
see: https://quran.api-docs.io/v4/getting-started/api-v3-v4-migration-guide

## Community
Join Quran.com community here https://discord.com/invite/FxRWSBfWxn


Tests
-------------
We have put some time to test the api and the search. You may need to have elasticsearch running in order for the tests to go through search although we should be looking for an elasticsearch mock.

Simply run:
```
rspec
```
