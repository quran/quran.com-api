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
require 'rails_helper'

RSpec.describe Audio::Station, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
