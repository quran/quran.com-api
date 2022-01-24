# == Schema Information
#
# Table name: radio_station_audio_files
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  audio_file_id    :integer
#  chapter_id       :integer
#  radio_station_id :integer
#
class Radio::StationAudioFile < ApplicationRecord
  belongs_to :radio_station, class_name: 'Radio::Station'
  belongs_to :chapter_audio_file, class_name: 'Audio::ChapterAudioFile'
end
