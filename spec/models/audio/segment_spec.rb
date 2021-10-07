# == Schema Information
#
# Table name: audio_segments
#
#  id                  :bigint           not null, primary key
#  duration            :integer
#  duration_ms         :integer
#  percentile          :float
#  segments            :jsonb
#  timestamp_from      :integer
#  timestamp_median    :integer
#  timestamp_to        :integer
#  verse_key           :string
#  verse_number        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_file_id       :bigint
#  audio_recitation_id :bigint
#  chapter_id          :bigint
#  verse_id            :bigint
#
# Indexes
#
#  index_audio_segments_on_audio_file_id                   (audio_file_id)
#  index_audio_segments_on_audio_file_id_and_verse_number  (audio_file_id,verse_number) UNIQUE
#  index_audio_segments_on_audio_recitation_id             (audio_recitation_id)
#  index_audio_segments_on_chapter_id                      (chapter_id)
#  index_audio_segments_on_verse_id                        (verse_id)
#  index_audio_segments_on_verse_number                    (verse_number)
#  index_on_audio_segments_median_time                     (audio_recitation_id,chapter_id,verse_id,timestamp_median)
#
require 'rails_helper'

RSpec.describe Audio::Segment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
