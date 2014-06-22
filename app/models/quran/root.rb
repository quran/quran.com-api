class Quran::Root < ActiveRecord::Base
    extend Quran

    self.table_name = 'root'
    self.primary_key = 'root_id'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'root_id'
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
    has_many :stems, class_name: 'Quran::Stem', through: :words
    has_many :terms, class_name: 'Quran::Term', through: :words
end
