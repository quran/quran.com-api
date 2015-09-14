module Search
  if Rails.env.production?
    @@client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
  else
    @@client = Elasticsearch::Client.new  # trace: true, log: true;
  end

  def self.client
    @@client
  end
end
