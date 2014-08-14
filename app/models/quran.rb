module Quran

    include Schema

    def self.extended(mod)
    	Rails.logger.error mod
    	mod.include(Elasticsearch::Model)
    	mod.include(Elasticsearch::Model::Callbacks)
    end


    Schema.schema_name = 'quran'
end
