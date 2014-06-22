class Quran::Ayah < ActiveRecord::Base
    extend Quran

    self.table_name = 'ayah'
    self.primary_key = 'ayah_key'

    belongs_to :surah, class_name: 'Quran::Surah'

    has_many :audio, class_name: 'Audio::File', foreign_key: 'ayah_key'
    has_many :texts, class_name: 'Quran::Text', foreign_key: 'ayah_key'
    has_many :words, class_name: 'Quran::Word', foreign_key: 'ayah_key'
    has_many :terms, class_name: 'Quran::Term', through: :words
    has_many :roots, class_name: 'Quran::Root', through: :words
    has_many :stems, class_name: 'Quran::Stem', through: :words

#    has_many :images, class_name => 'Quran::Image'
#    has_many :chars, class_name: 'Complex::Char', foreign_key: 'ayah_key'
#    tafsir_ayah
#    translation
#    transliteration
#    word_font
#    word_image_regular
#    word_image_tajweed
end
