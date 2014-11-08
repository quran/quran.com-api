module Searchable
  extend ActiveSupport::Concern

  # Setup the index mappings
  def self.setup_index
    models = [ Quran::Ayah, Content::Translation, Content::Transliteration, Quran::TextRoot]
    settings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__ ) ) )
    mappings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__ ) ) )

    models.first.__elasticsearch__.client.indices.create \
      index: "quran",
      body: { settings: settings, mappings: mappings }

    # TODO: loop through the models and import the indexes. This will take a while.
    # This should also be moved into a rake file.
  end

  def self.delete_index
    Quran::Ayah.__elasticsearch__.client.indices.delete index: Quran::Ayah.index_name rescue nil
  end


  # When this module is included, this callback function is called
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # Initial the paging gem, Kaminari
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

    class << self
      alias_method :importing, :import
      alias_method :searching, :search
    end

    self.index_name 'quran'
  end
end
