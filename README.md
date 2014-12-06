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

* To create the ElasticSearch index: `rake es_tasks:create_index`
* To delete it, run `rake es_tasks:delete_index`
* To check your mappings are registered correctly, browse to http://127.0.0.1:9200/quran/_mapping
* To delete and recreate only a single mapping from the rails console:

    client = Quran::Ayah.__elasticsearch__.client
    client.indices.delete_mapping index: 'quran', type: 'translation'
    client.indices.put_mapping index: 'quran', type: 'translation', body: { translation: { _parent: { type: 'ayah' }, _routing: { required: true, path: 'ayah_key' }, properties: { text: { type: 'string', term_vector: 'with_positions_offsets_payloads' } } } }

* Figuring out whats wrong with a query
  - Fire up a rails console:

    r = Quran::Ayah.search( "allah light", 1, 20, [ 'content.transliteration', 'content.translation' ] )
    debugme=r.instance_values['search'].instance_values['definition'][:body]
    print debugme.to_json, "\n"

    # {"query":{"bool":{"should":[{"has_child":{"type":"transliteration","query":{"match":{"text":{"query":"allah light","operator":"or","minimum_should_match":"3\u003c62%"}}}}},{"has_child":{"type":"translation","query":{"match":{"text":{"query":"allah light","operator":"or","minimum_should_match":"3\u003c62%"}}}}}],"minimum_number_should_match":1}}}

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
