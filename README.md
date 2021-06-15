# Quran.com API [![SLACK](http://i.imgur.com/Lk5HsBo.png)](https://quranslack.herokuapp.com)

[![Code Climate](https://codeclimate.com/github/quran/quran.com-api.png)](https://codeclimate.com/github/quran/quran.com-api)

## Getting started

Hi, Thank you for your interest in wanting support this inititive. Please follow the corresponding guidlines in accordance to your needs:

## Beginner - Windows

To set up your dev enviroment, there are multiple ways you can go about this:

1. Ruby dedicated IDE with PostgreSQL (Recommended: [RubyMine](https://www.jetbrains.com/ruby/))
2. Linux Distro with Ruby and PostgreSQL (Difficult to move files on windows)

Both have pro's and con's associated to them. However, as a beginner into coding; taking the IDE approach would be the most suitable as it would develop your understanding in familairising yourself with the files and what they're uses are.

Kindly note, when using a Ruby Dedicated IDE you would have to set up Ruby and Rails seperately.

Use [Ruby Installer](https://rubyinstaller.org/), with an IDE you are able to use each version seperately for each project!

### Steps to follow

#### 1. Install a IDE and PostgreSQL

#### 2. Fork this Repo

#### 3. Open the forked folder in the IDE

#### 4. Install the correct version of the requirements and bundle install

##### Requirements

- Rails 5.0.1
- Elasticsearch 5.0.1
- Ruby 3.0.0

if you are unaware of how to install the aforementioned requirements, please see [this](https://gorails.com/setup/ubuntu/21.04) guide.

##### Installations

Gems:

```
bundle install
```

Elasticsearch:
See config/elasticsearch/README.md

Postgresql:

This is the best way if you're on mac: <http://postgresapp.com/>
But to install the pg gem, you will have to do:

```
gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config
```

If you decide to install postgres with homebrew (`brew install postgresql`) you should not have this problem.

Why should you use the app? You have quick commandline tools such as:
The following tools come with Postgres.app:

PostgreSQL: clusterdb createdb createlang createuser dropdb droplang dropuser ecpg initdb oid2name pg_archivecleanup pg_basebackup pg_config pg_controldata pg_ctl pg_dump pg_dumpall pg_receivexlog pg_resetxlog pg_restore pg_standby pg_test_fsync pg_test_timing pg_upgrade pgbench postgres postmaster psql reindexdb vacuumdb vacuumlo

See: <http://postgresapp.com/documentation/cli-tools.html>

#### 5. Connect IDE to PostgreSQL Server

 You may need to configure your IDE settings, as connecting to DB settings on an IDE is most often found within the project settings or similar. Please see documentation of  your used IDE

 once connected, you should be running on your localhost e.g. -H 127.000.1: -p 5432  =  Default server

#### 6. (Only if your IDE suggets) - Install build settings

*Ignore if you have everything up-to-date* - You may recieve an onscreen promt to update build and other dependencies - go ahead with it

##### 7. See the documentation

<https://quran.api-docs.io/v3>

We have put some time to test the api and the search. You may need to have elasticsearch running in order for the tests to go through search although we should be looking for an elasticsearch mock.

Simply run:

```
rspec
```

### Database

It's private, we will not share complete dump. If you need mini version for contributing to quran.com, please join our slack channel and ask one of project's collaborator for access.

### Usage

```
http://localhost:3000/api/v3/chapters/1/verses
```

## Slack

Signup at <https://quranslack.herokuapp.com> to be added to the Slack group

**Thank you in advanced for your continuted support**
