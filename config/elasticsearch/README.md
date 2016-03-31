### Elasticsearch

#### Installation
Install via Homebrew
`brewi install elasticsearch`. You will then be prompted with this info:
```
==> Caveats
Data:    /usr/local/var/elasticsearch/elasticsearch_mmahalwy/
Logs:    /usr/local/var/log/elasticsearch/elasticsearch_mmahalwy.log
Plugins: /usr/local/Cellar/elasticsearch/2.2.0_1/libexec/plugins/
Config:  /usr/local/etc/elasticsearch/
plugin script: /usr/local/Cellar/elasticsearch/2.2.0_1/libexec/bin/plugin

To have launchd start elasticsearch at login:
  ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
Then to load elasticsearch now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
Or, if you don't want/need launchctl, you can just run:
  elasticsearch
==> Summary
```

That's where all the ES stuff is stored.

#### Plugins
##### Web view for seeing the indices in your browser:
```
/usr/local/Cellar/elasticsearch/2.2.0_1/libexec/bin/plugin install mobz/elasticsearch-head
```
Github: https://github.com/mobz/elasticsearch-head
To run: Open in browser http://localhost:9200/_plugin/head/

#### Starting
To run elasticsearch, in bash paste: Note: If you brew installed, this is done automatically

```
elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

#### Setup
copy the 'analysis/' subfolder into your elasticsearch directory (typically /opt/elasticsearch-1.6.0, for example, or /usr/share/elasticsearch), as 'config/analysis'

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

#### Groovy error
Follow this:
https://discuss.elastic.co/t/scripts-of-type-inline-operation-aggs-and-lang-groovy-are-disabled/2493

Simpy add `script.engine.groovy.inline.aggs: on` to your elasticsearch.yml


#### elasticsearch.yml config
Add these lines:

```
script.engine.groovy.inline.aggs: on
```

Optionally can add these lines:
```
script.disable_dynamic: false
threadpool.search.size: 24
threadpool.search.queue_size: 18708
```

#### ElasticSearch Optimization TODO NOTES

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
