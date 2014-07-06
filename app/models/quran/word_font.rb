class Quran::WordFont < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_font'
    self.primary_keys = :resource_id, :ayah_key, :position

    belongs_to :ayah, class_name: 'Quran::Ayah'
    belongs_to :char_type, class_name: 'Quran::CharType'
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :word, class_name: 'Quran::Word'
end
