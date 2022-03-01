# == Schema Information
# Schema version: 20220123232023
#
# Table name: radio_station_audio_files
#
#  id                    :integer          not null, primary key
#  radio_station_id      :integer
#  chapter_audio_file_id :integer
#  chapter_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_on_radio_audio_files  (radio_station_id,chapter_audio_file_id,chapter_id)
#

class Radio::StationAudioFile < ApplicationRecord
  belongs_to :radio_station, class_name: 'Radio::Station'
  belongs_to :chapter_audio_file, class_name: 'Audio::ChapterAudioFile'
end
