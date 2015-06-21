### Elasticsearch

#### Setup
copy the 'analysis/' subfolder into your elasticsearch directory (typically /opt/elasticsearch-1.6.0, for example, or /usr/share/elasticsearch), as 'config/analysis'

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
