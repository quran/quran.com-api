class Quran::Term < ActiveRecord::Base
    extend Quran

    self.table_name = 'term'
    self.primary_key = 'term_id'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'term_id'
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
end
