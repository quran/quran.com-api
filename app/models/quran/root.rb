class Quran::Root < ActiveRecord::Base
    extend Quran

    self.table_name = 'root'
    self.primary_key = 'root_id'

    has_many :_word_root, class_name: 'Quran::WordRoot', foreign_key: 'root_id'

    has_many :words, class_name: 'Quran::Word', through: :_word_root
    has_many :tokens, class_name: 'Quran::Token', through: :words
    has_many :stems, class_name: 'Quran::Stem', through: :words
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
end
