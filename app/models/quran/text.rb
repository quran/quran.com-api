class Quran::Text < ActiveRecord::Base
    extend Quran

    self.table_name = 'text'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :ayah, class_name: 'Quran::Ayah'
end
