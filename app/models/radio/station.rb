# == Schema Information
#
# Table name: audio_stations
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
#
# Indexes
#
#  index_audio_stations_on_audio_recitation_id  (audio_recitation_id)
#
class Radio::Station < ApplicationRecord
  include NameTranslateable

  belongs_to :audio_recitation, class_name: 'Audio::Recitation'
  has_many :chapter_audio_files, class_name: 'Audio::ChapterAudioFile', foreign_key: :audio_recitation_id
  has_many :radio_audio_files, class_name: 'Radio::AudioFile'
end
