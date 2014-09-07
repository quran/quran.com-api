module Content

    include Schema

    def self.extended(mod)
        Rails.logger.error mod
        mod.include(Elasticsearch::Model)
        mod.include(Elasticsearch::Model::Callbacks)
        mod.settings index: { number_of_shards: 1 } do
            mappings dynamic: 'false' do
            end
        end
        mod.index_name 'quran2'
    end

    Schema.schema_name = 'content'

end
