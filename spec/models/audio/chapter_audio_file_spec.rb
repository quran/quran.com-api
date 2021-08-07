# == Schema Information
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
require 'rails_helper'

RSpec.describe Audio::ChapterAudioFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
