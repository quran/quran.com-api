# vim: ts=4 sw=4 expandtab
module Searchable
    extend ActiveSupport::Concern

    @@models = [ 'Content::Translation', 'Content::Transliteration', 'Content::TafsirAyah',
                 'Quran::TextFont' ]
#    @@models = [ 'Quran::TextFont', 'Content::TafsirAyah' ]

    # convenience functions for setting up all indices in one go

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

    def self.import_index
        @@models.each do | model |
            model = Kernel.const_get( model )
            model.import_index
        end
    end

    def self.setup_index
        @@models.each do | model |
            model = Kernel.const_get( model )
            model.setup_index
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

            def self.delete_index( index_name )
                Rails.logger.info "deleting #{ index_name } index"

                # delete all the translation-* indices if the argument was just 'translation'
                if index_name == 'translation'
			begin
			    self.__elasticsearch__.client.cat.indices( index: 'translation-*', h: [ 'index' ], format: 'json' ).each do |d|
				if self.__elasticsearch__.client.indices.exists index: d['index']
					self.__elasticsearch__.client.indices.delete index: d['index']
				end
			    end
			rescue
			    Rails.logger.warn "no translation-* indices"
			end
                else
                    if self.__elasticsearch__.client.indices.exists index: index_name
                    	self.__elasticsearch__.client.indices.delete index: index_name
		    end
                end
            end

            def self.create_index( index_name, extra_text_mapping_opts = {} )
                Rails.logger.info "creating #{ index_name } index"

#                if index_name == 'translation'
#                    Rails.logger.debug "skipping create_index on translation because this is a hack"
#                    return
#                end
                if self.__elasticsearch__.client.indices.exists index: index_name
                    Rails.logger.warn "#{ index_name } already exists"
                    return
                end

                settings     = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__ ) ) )
                mappings_all = YAML.load( File.read( File.expand_path( "#{Rails.root}/config/elasticsearch/mappings.yml", __FILE__ ) ) )
                mappings     = {}

                #mappings[ 'ayah' ] = mappings_all[ 'ayah' ]
                if mappings_all.key? index_name
                    mappings[ 'data' ] = mappings_all[ index_name ]
                elsif index_name.match( /-/ )
                    index_name_fallback = index_name.split( /-/ )
                    index_name_fallback = index_name_fallback.slice( 0, index_name_fallback.length - 1 ).join( '-' )
                    if mappings_all.key? index_name_fallback
                        mappings[ 'data' ] = mappings_all[ index_name_fallback ]
                    end
                end
                if not mappings.key? 'data'
                    raise "elasticsearch mapping for #{ index_name } not configured; check config/elasticsearch/mappings.yml"
                end

                # NOTE this is a hack to let the import routine in Content::Translation to pass in analyzer settings like so:
                # self.create_index( index_name_lc, { analyzer: es_analyzer_default } ) TODO put it in mappings.yml?
                if extra_text_mapping_opts
                    mappings[ 'data' ][ 'properties' ][ 'text' ][ 'fields' ][ 'stemmed' ].merge! extra_text_mapping_opts
                    Rails.logger.debug( "extra_text_mapping_opts #{extra_text_mapping_opts}" )
                end

                self.__elasticsearch__.client.indices.create \
                    index: index_name, body: { settings: settings, mappings: mappings }

                Rails.logger.debug( "index_name #{index_name} mappings #{mappings}" )

                # NOTE 1.1 we want to import the stock ayah document because it serves as a "parent" across all indices
                #Quran::Ayah.import( { index: index_name, type: 'ayah' } )
            end

            def self.import_index( index_name , opts = {} )
                Rails.logger.info "importing #{ index_name } index"

                # NOTE 1.2 and this imports the "child" content data (see NOTE 1.1)
                self.import( { index: index_name }.merge( opts ) )
            end


            def self.setup_index( index = index_name , opts = {} )
                Rails.logger.info "setting up #{ index } index"

                self.delete_index( index )
                self.create_index( index )
                self.import_index( index, opts )
            end

            # NOTE this is temporary -- nour
            def self.debug_query ( query, types )
                Rails.logger.info( "#{ self }.debug_query" )

                client = self.__elasticsearch__.client
                matched_parents = self.matched_parents( query, types )
                matched_parents_query = self.matched_parents_query( query, types )
                ayah_keys = matched_parents.map { |tup| tup[0] }
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
