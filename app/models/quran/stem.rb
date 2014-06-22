class Quran::Stem < ActiveRecord::Base
    extend Quran

    self.table_name = 'stem'
    self.primary_key = 'stem_id'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'stem_id'
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
    has_many :terms, class_name: 'Quran::Term', through: :words
end
