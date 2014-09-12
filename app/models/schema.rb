module Schema
    # mattr_accessor :schema_name


    @@schema_name = Hash.new
    def table_name
        @@schema_name[self.name.split("::").first.downcase] +'.'+ super
        # Rails.logger.ap self.name.split("::").first.downcase
        # Rails.logger.ap @@schema_name[self.name.split("::").first.downcase]
        
    end

    def self.schema_name
        @@schema_name
    end

    def self.schema_name=(schema_name)
        @@schema_name["#{schema_name}"] = schema_name
    end
 
    def self.included( mod )
        def mod.extended( mod )
            Rails.logger.debug( 'RAILS ROOT '+ File.dirname( __FILE__ ) )
            settings = YAML.load_file( "config/elasticsearch/settings.yml" )
            #Rails.logger.debug( settings.to_hash )
            Rails.logger.error mod
            mod.include(Elasticsearch::Model)
            mod.include(Elasticsearch::Model::Callbacks)
            mod.settings settings do
                mappings dynamic: 'false' do
                end
            end
            mod.index_name 'quran2'
        end
    end
end
