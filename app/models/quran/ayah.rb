class Quran::Ayah < ActiveRecord::Base
    extend Quran

    self.table_name = 'ayah'
    self.primary_key = 'ayah_key'
    # Rails.logger.ap self.table_name
    belongs_to :surah, class_name: 'Quran::Surah'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'ayah_key'

    has_many :tokens, class_name: 'Quran::Token', through: :words
    has_many :stems, class_name:  'Quran::Stem',  through: :words
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :roots, class_name:  'Quran::Root',  through: :words

    has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'ayah_key'

    has_many :audio, class_name: 'Audio::File', foreign_key: 'ayah_key'
    has_many :texts, class_name: 'Quran::Text', foreign_key: 'ayah_key'
    has_many :images, class_name: 'Quran::Image', foreign_key: 'ayah_key'
    has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: 'ayah_key'
    has_many :tafsirs, class_name: 'Content::Tafsir', through: :_tafsir_ayah
    has_many :translations, class_name: 'Content::Translation', foreign_key: 'ayah_key'
    has_many :transliterations, class_name: 'Content::Transliteration', foreign_key: 'ayah_key'


    def self.fetch_ayahs(surah_id, from, to)
        self
        .where("quran.ayah.surah_id = ? AND quran.ayah.ayah_num >= ? AND quran.ayah.ayah_num <= ?", surah_id, from, to)
        .order("quran.ayah.surah_id, quran.ayah.ayah_num")
    end
end
