# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_chapter_audio_files
#
#  id                  :integer          not null, primary key
#  chapter_id          :integer
#  audio_recitation_id :integer
#  total_files         :integer
#  stream_count        :integer
#  download_count      :integer
#  file_size           :float
#  bit_rate            :integer
#  duration            :integer
#  file_name           :string
#  format              :string
#  mime_type           :string
#  metadata            :jsonb            default("{}")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_content_id :integer
#  duration_ms         :integer
#  audio_url           :string
#  timing_percentiles  :string           is an Array
#
# Indexes
#
#  index_audio_chapter_audio_files_on_audio_recitation_id  (audio_recitation_id)
#  index_audio_chapter_audio_files_on_chapter_id           (chapter_id)
#  index_audio_chapter_audio_files_on_format               (format)
#  index_audio_chapter_audio_files_on_resource_content_id  (resource_content_id)
#

class Audio::ChapterAudioFile < ApplicationRecord
  belongs_to :audio_recitation, class_name: 'Audio::Recitation'
  belongs_to :chapter
  has_many :audio_segments, class_name: 'Audio::Segment', foreign_key: 'audio_file_id'
end
