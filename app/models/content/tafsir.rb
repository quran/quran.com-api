# == Schema Information
#
# Table name: tafsir
#
#  tafsir_id   :integer          not null, primary key
#  resource_id :integer          not null
#  text        :text             not null
#

class Content::Tafsir < ActiveRecord::Base
    self.table_name = 'tafsir'

    # relationships
    belongs_to :resource,  class_name: 'Content::Resource'
    has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'tafsir_id'
    has_many :ayahs, class_name: 'Quran::Ayah', through: :_tafsir_ayah
end
# notes:
# - provides a 'text' column
