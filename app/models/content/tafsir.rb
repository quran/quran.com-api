class Content::Tafsir < ActiveRecord::Base
    extend Content

    self.table_name = 'tafsir'
    self.primary_key = 'tafsir_id'

    # relationships
    belongs_to :resource,  class_name: 'Content::Resource'
    has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'tafsir_id'
    has_many :ayahs, class_name: 'Quran::Ayah', through: :_tafsir_ayah
end
# notes:
# - provides a 'text' column
