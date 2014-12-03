module Searchable
    extend ActiveSupport::Concern

    # Setup the index mappings
    def self.setup_index
        models = [
            Quran::Ayah,
            Content::Translation, Content::Transliteration, Content::TafsirAyah,
            Quran::Text, Quran::TextRoot, Quran::TextStem, Quran::TextLemma, Quran::TextToken
        ]
        settings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__ ) ) )
        mappings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__ ) ) )

        models.first.__elasticsearch__.client.indices.create \
            index: "quran",
            body: { settings: settings, mappings: mappings }

        models.each do |m|
            m.import
        end
    end

    def self.delete_index
        Quran::Ayah.__elasticsearch__.client.indices.delete index: Quran::Ayah.index_name rescue nil
    end


    # When this module is included, this callback function is called
    included do |mod|
        Rails.logger.info( "searchable included into #{ mod } !!!" )
        mod.class_eval do
            def self.debug_query ( query, types )
                Rails.logger.info( "this is debug query in #{ self } mod !!!" )

                client = self.__elasticsearch__.client
                matched_parents = self.matched_parents( query, types )
                matched_parents_query = self.matched_parents_query( query, types )
                ayah_keys = matched_parents.map{ |r| r._source.ayah_key }
                matched_children = ( OpenStruct.new self.matched_children( query, types, ayah_keys ) ).responses
                matched_children_query = self.matched_children_query( query, types, ayah_keys )
                return {
                    client: client,
                    parent: {
                        result: matched_parents,
                        query: matched_parents_query,
                        keys: ayah_keys
                    },
                    child: {
                        result: matched_children,
                        query: matched_children_query
                    }
                }
            end


            Rails.logger.info( "this is class eval #{ mod } !!!" )

        end

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
