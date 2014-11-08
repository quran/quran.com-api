#README

-------
NOTES
=====

Database
--------

Setup should be a three step dance.

1. Look at config/database.yml and create the configured database and user. This is an exercise left
   to the reader, but in a nutshell: install postgres, create the db, create the user with sufficient privileges so that it can drop/create the database.
2. rake db:reset
3. rake db:migrate

If you're comfortable enough with postgres and intend to poke in the database at a lower level, then also set
your schema search path:

    alter database quran_dev set search_path = "$user", quran, content, audio, i18n, public;


Elasticsearch
-------------

It's painful. But this will help a lot:

* Web portal: sudo plugin -install mobz/elasticsearch-head
    * Git: https://github.com/mobz/elasticsearch-head
    * `open http://localhost:9200/_plugin/head/`
* To view all indices
    * http://localhost:9200/_cat/indices?v
* Problems with indices or routing? (RoutingMissingException)
    * Delete the index
    * http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-delete-index.html
* View mappings:
    * http://localhost:9200/bookstore/_mapping

* ElasticSearch client API:
    - This should come in handy if the rails extension just isn't cutting it. You can get to it via the model class,
      e.g. Quran::Text.__elasticsearch__.client
    - http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API
    - https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api

* How to forcefully delete and recreate the index from the rails console:

    client = Quran::Ayah.__elasticsearch__.client
    client.indices.delete index: 'quran'
    Searchable.setup_index_mappings

    # then browse to http://127.0.0.1:9200/quran/_mapping to confirm correct

* How to import from the rails console:

    Quran::Ayah.import
    Quran::Text.import
    Content::Translation.import
    # ...etc

* How to delete and recreate only a single mapping from the rails console:

    client = Quran::Ayah.__elasticsearch__.client
    client.indices.delete_mapping index: 'quran', type: 'text'
    client.indices.put_mapping index: 'quran', type: 'text', # ... TODO (figure this out and document it)

