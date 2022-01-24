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
require 'rails_helper'

RSpec.describe Audio::StationAudioFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
