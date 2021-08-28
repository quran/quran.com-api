options = if ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
            {host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']}
          else
            {
                host: '127.0.0.1',
                password: ENV['ELASTICSEARCH_PASSWORD'],
                user: ENV['ELASTICSEARCH_USERNAME']
            }
          end.merge(adapter: :typhoeus)

Elasticsearch::Model.client = Elasticsearch::Client.new(options.compact_blank)

