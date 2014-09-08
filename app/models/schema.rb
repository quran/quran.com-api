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


    def include_elasticsearch(mod)
        Rails.logger.info mod
        
        # mod = Object.const_get("#{mod}")
        mod.include(Elasticsearch::Model)
        mod.include(Elasticsearch::Model::Callbacks)
        mod.settings index: { number_of_shards: 1 } do
            mappings dynamic: 'false' do
            end
        end
        mod.index_name 'quran2'

    end

    def self.included(mod)
        Rails.logger.info mod
        mod.instance_eval do 
            def extended(mod)
                mod.send :include_elasticsearch, mod
            end
        end
    end
end
