class Quran::Image < ActiveRecord::Base
    extend Quran

    self.table_name = 'image'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'
end

