module I18n
  include Schema

  	def self.extended(mod)
    	Rails.logger.error mod
    	mod.include(Elasticsearch::Model)
    	mod.include(Elasticsearch::Model::Callbacks)
    end


  @@schema_name = 'i18n'
end
