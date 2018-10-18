options = if ENV['ELASTICSEARCH_HOST']
  {host: ENV['ELASTICSEARCH_HOST']}
else
  {}  # trace: true, log: true;
end.merge adapter: :excon

Elasticsearch::Model.client = Elasticsearch::Client.new options
