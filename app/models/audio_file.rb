# frozen_string_literal: true

# == Schema Information
#
# Table name: audio_files
#
#  id            :integer          not null, primary key
#  duration      :integer
#  format        :string
#  hizb_number   :integer
#  is_enabled    :boolean
#  juz_number    :integer
#  mime_type     :string
#  page_number   :integer
#  rub_number    :integer
#  segments      :text
#  url           :text
#  verse_key     :string
#  verse_number  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chapter_id    :integer
#  recitation_id :integer
#  verse_id      :integer
#
# Indexes
#
#  index_audio_files_on_chapter_id                   (chapter_id)
#  index_audio_files_on_chapter_id_and_verse_number  (chapter_id,verse_number)
#  index_audio_files_on_hizb_number                  (hizb_number)
#  index_audio_files_on_is_enabled                   (is_enabled)
#  index_audio_files_on_juz_number                   (juz_number)
#  index_audio_files_on_page_number                  (page_number)
#  index_audio_files_on_recitation_id                (recitation_id)
#  index_audio_files_on_rub_number                   (rub_number)
#  index_audio_files_on_verse_id                     (verse_id)
#  index_audio_files_on_verse_key                    (verse_key)
#

class AudioFile < ApplicationRecord
  belongs_to :verse
  belongs_to :recitation

  serialize :segments, Array
end
