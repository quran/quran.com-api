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
```
brew install elasticsearch
```

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

Elasticsearch
-------------

The search engine used to query the Quran.

#### Starting
To run elasticsearch, in bash paste:

```
elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```
#### Plugin

To install: Web portal: sudo elasticsearch/bin/plugin -install mobz/elasticsearch-head

Github:  https://github.com/mobz/elasticsearch-head

To run: Open in browser `http://localhost:9200/_plugin/head/`

If you’ve installed the .deb package, then the plugin exectuable will be available at /usr/share/elasticsearch/bin/plugin.

#### Indices
```
http://localhost:9200/_cat/indices?v
```

#### Indices or routing? (RoutingMissingException)
    * Delete the index
    * http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-delete-index.html

#### Mappings
View mappings: in browser - `http://localhost:9200/quran/_mapping`

#### ElasticSearch client API:
    - This should come in handy if the rails extension just isn't cutting it. You can get to it via the model class,
      e.g. Quran::Text.__elasticsearch__.client
    - http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API
    - https://github.com/elasticsearch/elasticsearch-ruby/tree/master/elasticsearch-api



#### Pre-build tasks:
* To create the ElasticSearch index: `rake es_tasks:setup_index`
* To delete it, run `rake es_tasks:delete_index`
* To delete and recreate only a single mapping from the rails console:
```
    client = Quran::Ayah.__elasticsearch__.client
    client.indices.delete_mapping index: 'quran', type: 'translation'
    client.indices.put_mapping index: 'quran', type: 'translation', body: { translation: { _parent: { type: 'ayah' }, _routing: { required: true, path: 'ayah_key' }, properties: { text: { type: 'string', term_vector: 'with_positions_offsets_payloads' } } } }
```

**Note**: you will run into the problem of not having the arabic_synonyms.txt file in the proper location for elasticsearch. That's fine. The file is located in the public directory and should be placed in `/etc/elasticsearch/analysis` on your server.

#### Querying

  * Figuring out whats wrong with a query
  - Fire up a rails console:

    r = Quran::Ayah.search( "allah light", 1, 20, [ 'content.transliteration', 'content.translation' ] )
    debugme=r.instance_values['search'].instance_values['definition'][:body]
    print debugme.to_json, "\n"

    ```
    {"query":{"bool":{"should":[{"has_child":{"type":"transliteration","query":{"match":{"text":{"query":"allah light","operator":"or","minimum_should_match":"3\u003c62%"}}}}},{"has_child":{"type":"translation","query":{"match":{"text":{"query":"allah light","operator":"or","minimum_should_match":"3\u003c62%"}}}}}],"minimum_number_should_match":1}}}
    ```

  - Copy and paste that output into the 'Any Request' tab of http://127.0.0.1:9200/_plugin/head/

ElasticSearch Optimization TODO NOTES
-------------------------------------

- normalize western languages (stemming, etc.)
* factor in frequency, density, proximity to each other, and proximity to the beginning of the ayah (seems like it's not factored in)
  - frequency, i.e. if 'allah light' matches 'allah' once, and 'light' twice in the same result, then that
    result needs a higher score than matching only 'allah' once and 'light' once
  - density, i.e. if 'allah light' matches an ayah which is only 5 tokens long, e.g. 'allah word_a light word_b word_c'
    then this has a higher density then a match against a result which is 300 words long and should respectively
    have a higher score
  - proximity to each other, i.e. 'allah light' matching 'allah word light word word word' gets a better score then
    a match against 'allah word word word word word word light'
  - proximity to the beginning of the ayah, i.e. if 'allah light' matches a translation which is 'allah is the light of word word word word word word'
    then this should have a higher score then 'word word word word word word word allah word word word word light'
- normalize arabic using techniques to-be-determined involving root, stem, lemma
- improving relevance:
    - this document: http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/relevance-intro.html
    - in combination with a rails console inspection of:

    matched_children = ( OpenStruct.new Quran::Ayah.matched_children( query, config[:types], array_of_ayah_keys ) ).responses


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
