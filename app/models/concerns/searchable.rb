module Searchable
  extend ActiveSupport::Concern


  def self.setup_index
    models = [Content::Translation, Content::Transliteration, Quran::Ayah]
    mappings = Hash.new

    models.each do |model|
      mappings = mappings.merge(model.mappings.to_hash)
    end
    
      models.first.__elasticsearch__.client.indices.create \
        index: "quran",
        body: { settings: models.first.settings.to_hash, mappings: mappings }
    # end
  end 

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

    class << self
        alias_method :importing, :import
        alias_method :searching, :search
    end

    self.settings index: { number_of_shards: 1 } do
        mappings dynamic: 'strict' do
        end
    end
    self.index_name 'quran'
    # self.document_type = self.name.split("::").first.downcase
    


    

    # Rails.logger.error Rails.root
    # YAML.load(File.read(File.expand_path("#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__)))
    # 
    
    # mapping do
    #   # ...
    # end

    # def self.search(query)
    #   # ...
    # end
  end
end
