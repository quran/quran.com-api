if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
else
  Elasticsearch::Model.client = Elasticsearch::Client.new  # trace: true, log: true;
end
