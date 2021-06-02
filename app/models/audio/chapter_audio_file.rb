# frozen_string_literal: true

# == Schema Information
#
# Table name: audio_chapter_audio_files
#
#  id                  :bigint           not null, primary key
#  bit_rate            :integer
#  download_count      :integer
#  duration            :integer
#  file_name           :string
#  file_size           :integer
#  format              :string
#  metadata            :jsonb
#  mime_type           :string
#  stream_count        :integer
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

  def audio_url
    "https://download.quranicaudio.com/quran/#{relative_path}/#{file_name}"
  end

  def relative_path
    audio_recitation.relative_path
  end
end
