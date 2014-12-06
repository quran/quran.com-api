DB INITIAL SETUP
================

1. prepare your user (i.e. "quran_dev") by granting it the createdb privilege:

    (as postgres user)
    alter user quran_dev with createdb

2.follow up in psql by setting your search path:

    alter database quran_dev set search_path = "$user", quran, content, audio, i18n, public

3. mv db/structure.sql.init to db/structure.sql

4. initialize your db with:

    rake db:reset
    rake db:migrate

5. if migrations don't apply even though you reset (weird issue, happened to me), then truncate the schema_migrations table and try `rake db:migrate` again


NOTES
=====

- db/base/ was created using the 'yaml_db' gem (it's in the Gemfile) and running 'rake db:data:dump'.
  it's used in the first migration script to import data via the call 'Rake::Task['db:data:load_dir'].invoke'.
- db/structure.sql was creating by calling 'rake db:structure:dump'. it's used alternatively instead of
  db/schema.rb to create the initial schema and structure of the database when calling 'rake db:reset'. the
  flag which opts for reading this file instead is the setting 'config.active_record.schema_format = :sql'
  in config/application.rb
