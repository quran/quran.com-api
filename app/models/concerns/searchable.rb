module Searchable
    extend ActiveSupport::Concern

    # Setup the index mappings
    def self.setup_index
        models = [
            Content::Translation, Content::Transliteration, Content::TafsirAyah,
            Quran::Text, Quran::TextRoot, Quran::TextStem, Quran::TextLemma, Quran::TextToken
        ]

        models.each do |m|
            m.create_index
        end
    end

    def self.delete_index
        models = [
            Content::Translation, Content::Transliteration, Content::TafsirAyah,
            Quran::Text, Quran::TextRoot, Quran::TextStem, Quran::TextLemma, Quran::TextToken
        ]

        models.each do |m|
            m.delete_index
        end
    end


    # When this module is included, this callback function is called
    included do |mod|
        Rails.logger.info( "searchable included into #{ mod } !!!" )

        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        mod.class_eval do
            index_name document_type # e.g. translation
            document_type "data"     # e.g. rename from translation to just "data"
            Rails.logger.info( "!!! #{ self } index name is #{ index_name } and document type is #{ document_type }" )

            def self.delete_index
                if self.__elasticsearch__.client.indices.exists index: index_name
                    self.__elasticsearch__.client.indices.delete index: index_name
                end
            end

            def self.create_index
                Rails.logger.info( "!!! #{ self } index name is #{ index_name } and document type is #{ document_type }" )
                settings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__ ) ) )
                all_mappings = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__ ) ) )
                mappings = {}
                mappings[ 'ayah' ] = all_mappings[ 'ayah' ]
                mappings[ 'data' ] = all_mappings[ index_name ]
                self.__elasticsearch__.client.indices.create \
                    index: index_name, body: { settings: settings, mappings: mappings }

                # import into the 'ayah' type
                Quran::Ayah.import( { index: index_name, type: 'ayah' } )

                # import into the 'data' type
                self.import
            end

            def self.recreate_index
                self.delete_index
                self.create_index
            end

            def self.debug_query ( query, types )
                Rails.logger.info( "this is debug query in #{ self } mod !!!" )

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


            Rails.logger.info( "this is class eval #{ mod } !!!" )

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
