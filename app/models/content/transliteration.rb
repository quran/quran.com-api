class Content::Transliteration < ActiveRecord::Base
    extend Content

    self.table_name = 'transliteration'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'
end
# notes:
# - provides a 'text' column
