# vim: ts=4 sw=4 expandtab
module Searchable
    extend ActiveSupport::Concern

    @@models = [ 'Content::Translation', 'Content::Transliteration', 'Content::TafsirAyah',
                 'Quran::Text', 'Quran::TextRoot', 'Quran::TextStem', 'Quran::TextLemma', 'Quran::TextToken' ]

    # convenience functions for creating/recreating/deleting all indexes in one go

    def self.create_index
        @@models.each do | model |
            model = Kernel.const_get( model )
            model.create_index
        end
    end

    def self.delete_index
        @@models.each do | model |
            model = Kernel.const_get( model )
            model.delete_index
        end
    end

    def self.recreate_index
        @@models.each do | model |
            model = Kernel.const_get( model )
            model.recreate_index
        end
    end


    # TODO this is so convoluted, I don't know what's happening anymore -- our multiple inheritance/mix-in strategy should be more elegant
    # When this module is included, this callback function is called
    included do |mod|
        Rails.logger.info( "searchable included into #{ mod } !!!" )

        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        mod.class_eval do
            index_name document_type # e.g. translation
            document_type "data"     # e.g. rename from translation to just "data"

            def self.delete_index
                Rails.logger.info "deleting #{ index_name } index"

                if not self.__elasticsearch__.client.indices.exists index: index_name
                    Rails.logger.warn "#{ index_name } didn't exist"
                    return
                end

                self.__elasticsearch__.client.indices.delete index: index_name
            end

            def self.create_index
                Rails.logger.info "creating #{ index_name } index"

                if self.__elasticsearch__.client.indices.exists index: index_name
                    Rails.logger.warn "#{ index_name } already exists"
                    return
                end

                settings     = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__ ) ) )
                mappings_all = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__ ) ) )
                mappings     = {}

                mappings[ 'ayah' ] = all_mappings[ 'ayah' ]
                mappings[ 'data' ] = all_mappings[ index_name ]

                self.__elasticsearch__.client.indices.create \
                    index: index_name, body: { settings: settings, mappings: mappings }

                # we want to import the stock ayah document because it serves as a "parent" across all indices
                Quran::Ayah.import( { index: index_name, type: 'ayah' } )

                # and this imports the "child" content data
                self.import
            end

            def self.recreate_index
                Rails.logger.info "recreating #{ index_name } index"

                self.delete_index
                self.create_index
            end

            # this is temporary -- nour
            def self.debug_query ( query, types )
                Rails.logger.info( "#{ self }.debug_query" )

                client = self.__elasticsearch__.client
                matched_parents = self.matched_parents( query, types )
                matched_parents_query = self.matched_parents_query( query, types )
                ayah_keys = matched_parents['hits']['hits'].map{ |r| r['_source']['ayah_key'] }
                matched_children = ( OpenStruct.new self.matched_children( query, types, ayah_keys ) ).responses
                matched_children_query = self.matched_children_query( query, types, ayah_keys )

                simple_query = matched_children_query[:body][0][:search][:query].deep_dup
                simple_query[:bool][:must].shift()
                simple_query = { :body => { query: simple_query }, :explain => true }
                simple_result = client.search( simple_query )

                return {

                    client: client,
                    simple: {
                        result: simple_result,
                        query: simple_query
                    },
                    combined: {
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
                }
            end
        end

        # Initial the paging gem, Kaminari
        Kaminari::Hooks.init
        Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

        class << self
            alias_method :importing, :import
            alias_method :searching, :search
        end
    end
end
