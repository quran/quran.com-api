module Search
  def self.client
    Elasticsearch::Model.client
  end
end
