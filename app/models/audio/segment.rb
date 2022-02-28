# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_segments
#
#  id                       :integer          not null, primary key
#  audio_file_id            :integer
#  audio_recitation_id      :integer
#  chapter_id               :integer
#  verse_id                 :integer
#  verse_key                :string
#  verse_number             :integer
#  timestamp_from           :integer
#  timestamp_to             :integer
#  timestamp_median         :integer
#  segments                 :jsonb            default("[]")
#  duration                 :integer
#  duration_ms              :integer
#  percentile               :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  silent_duration          :integer
#  relative_segments        :jsonb            default("[]")
#  relative_silent_duration :integer
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

class Audio::Segment < ApplicationRecord
  belongs_to :verse
  belongs_to :chapter
  belongs_to :audio_recitation, class_name: 'Audio::Recitation'
  belongs_to :audio_file, class_name: 'Audio::ChapterAudioFile'
end
