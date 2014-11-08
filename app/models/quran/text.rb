class Quran::Text < ActiveRecord::Base
    extend Quran
    extend Batchelor

    self.table_name = 'text'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'

    def self.import(options = {})
        transform = lambda do |a|
            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}} 
        end
        options = { transform: transform, batch_size: 6236 }.merge(options)
        self.importing options 
    end


end
