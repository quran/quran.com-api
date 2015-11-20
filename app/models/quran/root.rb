# == Schema Information
#
# Table name: quran.root
#
#  root_id :integer          not null, primary key
#  value   :string(50)       not null
#

class Quran::Root < ActiveRecord::Base
    extend Quran
    # extend Batchelor

    self.table_name = 'root'
    self.primary_key = 'root_id'

    has_many :_word_root, class_name: 'Quran::WordRoot', foreign_key: 'root_id'

    has_many :words, class_name: 'Quran::Word', through: :_word_root
    has_many :tokens, class_name: 'Quran::Token', through: :words
    has_many :stems, class_name: 'Quran::Stem', through: :words
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :ayahs, class_name: 'Quran::Ayah', through: :words

#    def self.import(options = {})
#        transform = lambda do |a|
#            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}} 
#        end
#        options = {transform: transform}.merge(options)
#        self.importing options 
#    end


end
