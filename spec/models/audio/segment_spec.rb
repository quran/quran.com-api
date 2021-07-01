# == Schema Information
#
# Table name: audio_segments
#
#  id              :bigint           not null, primary key
#  duration        :integer
#  end_timestamp   :integer
#  percentile      :float
#  segments        :string           default([]), is an Array
#  start_timestamp :integer
#  verse_number    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  audio_file_id   :bigint
#  chapter_id      :bigint
#  verse_id        :bigint
#
# Indexes
#
#  index_audio_segments_on_audio_file_id                   (audio_file_id)
#  index_audio_segments_on_audio_file_id_and_verse_number  (audio_file_id,verse_number)
#  index_audio_segments_on_chapter_id                      (chapter_id)
#  index_audio_segments_on_end_timestamp                   (end_timestamp)
#  index_audio_segments_on_start_timestamp                 (start_timestamp)
#  index_audio_segments_on_verse_id                        (verse_id)
#
require 'rails_helper'

RSpec.describe Audio::Segment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
