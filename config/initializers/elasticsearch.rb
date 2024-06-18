require 'typhoeus'

# https://github.com/typhoeus/typhoeus/pull/582
Faraday::Adapter.register_middleware typhoeus: :Typhoeus

options = if ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
            {host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']}
          else
            {
                url: ENV['ELASTICSEARCH_URL'],
                password: ENV['ELASTICSEARCH_PASSWORD'],
                user: ENV['ELASTICSEARCH_USERNAME'],
                transport_options: {
                  ssl: {
                    verify: false
                  }
                },
            }
          end

# try httpx adapter https://github.com/honeyryderchuck/httpx
# https://honeyryderchuck.gitlab.io/httpx/wiki/Faraday-Adapter
options[:adapter] = :typhoeus
Elasticsearch::Model.client = Elasticsearch::Client.new(options.compact_blank)
