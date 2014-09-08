module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    class << self
        alias_method :importing, :import
    end

    self.settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
        end
    end
    self.index_name 'quran2'
    # mapping do
    #   # ...
    # end

    # def self.search(query)
    #   # ...
    # end
  end
end
