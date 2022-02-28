# == Schema Information
# Schema version: 20220123232023
#
# Table name: radio_stations
#
#  id                  :integer          not null, primary key
#  name                :string
#  cover_image         :string
#  profile_picture     :string
#  description         :text
#  audio_recitation_id :integer
#  parent_id           :integer
#  priority            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_radio_stations_on_audio_recitation_id  (audio_recitation_id)
#  index_radio_stations_on_parent_id            (parent_id)
#  index_radio_stations_on_priority             (priority)
#

class Radio::Station < ApplicationRecord
  include NameTranslateable

  belongs_to :parent, class_name: 'Radio::Station',  optional: true
  has_many :sub_stations, class_name: 'Radio::Station', foreign_key: 'parent_id'
  has_many :radio_audio_files, class_name: 'Radio::AudioFile'
end
