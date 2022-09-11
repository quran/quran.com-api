# frozen_string_literal: true
# == Schema Information
# Schema version: 20220123232023
#
# Table name: audio_chapter_audio_files
#
#  id                  :bigint           not null, primary key
#  audio_url           :string
#  bit_rate            :integer
#  download_count      :integer
#  duration            :integer
#  duration_ms         :integer
#  file_name           :string
#  file_size           :float
#  format              :string
#  metadata            :jsonb
#  mime_type           :string
#  stream_count        :integer
#  timing_percentiles  :string           is an Array
#  total_files         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_recitation_id :integer
#  chapter_id          :integer
#  resource_content_id :integer
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

  def self.episodes
    joins("left join reciters as r on metadata->>'artist' = r.name;")
      .select("r.name as reciter_name, r.profile_picture as reciter_photo, r.bio,
        audio_url, metadata->>'title' as chapter_name ")
        
  end
end
