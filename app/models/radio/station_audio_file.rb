# == Schema Information
#
# Table name: audio_station_audio_files
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  audio_file_id    :integer
#  chapter_id       :integer
#  radio_station_id :integer
#
# Indexes
#
#  index_on_radio_audio_files  (radio_station_id,audio_file_id,chapter_id)
#
class Audio::StationAudioFile < ApplicationRecord
  belongs_to :radio_station, class_name: 'Radio::Station'
  belongs_to :chapter_audio_file, class_name: 'Audio::ChapterAudioFile'
end
