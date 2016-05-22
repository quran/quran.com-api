# == Schema Information
#
# Table name: audio.reciter
#
#  reciter_id :integer          not null, primary key
#  path       :text
#  slug       :text
#  english    :text             not null
#  arabic     :text             not null
#

class Audio::Reciter < ActiveRecord::Base
  extend Audio

  self.table_name = 'reciter'
  self.primary_key = 'reciter_id'

  has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'reciter_id'
  has_many :files, class_name: 'Audio::File', through: :recitations, source: :audio
end
