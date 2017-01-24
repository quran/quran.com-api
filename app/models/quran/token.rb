# == Schema Information
#
# Table name: token
#
#  token_id :integer          not null, primary key
#  value    :string(50)       not null
#  clean    :string(50)       not null
#

class Quran::Token < ActiveRecord::Base
    self.table_name = 'token'
    #self.primary_key = 'token_id'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'token_id'
    has_many :stems, class_name: 'Quran::Stem', through: :words
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :roots, class_name: 'Quran::Root', through: :words
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words
end
