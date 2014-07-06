class Quran::Stem < ActiveRecord::Base
    extend Quran

    self.table_name = 'stem'
    self.primary_key = 'stem_id'

    has_many :_word_stem, class_name: 'Quran::WordStem', foreign_key: 'stem_id'

    has_many :words, class_name: 'Quran::Word', through: :_word_stem
    has_many :tokens, class_name: 'Quran::Token', through: :words # uniq ?
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :roots, class_name: 'Quran::Root', through: :words
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
end
