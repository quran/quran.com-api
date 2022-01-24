# == Schema Information
#
# Table name: radio_stations
#
#  id                  :bigint           not null, primary key
#  cover_image         :string
#  description         :text
#  name                :string
#  priority            :integer
#  profile_picture     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_recitation_id :integer
#  parent_id           :integer
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
