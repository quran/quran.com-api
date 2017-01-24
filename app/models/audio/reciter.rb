# == Schema Information
#
# Table name: reciter
#
#  reciter_id :integer          not null, primary key
#  path       :text
#  slug       :text
#  english    :text             not null
#  arabic     :text             not null
#

class Audio::Reciter < ActiveRecord::Base
  self.table_name = 'reciter'

  has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'reciter_id'
  has_many :files, class_name: 'Audio::File', through: :recitations, source: :audio
end
