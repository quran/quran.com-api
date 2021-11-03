# frozen_string_literal: true

# == Schema Information
#
# Table name: tafsirs
#
#  id                   :integer          not null, primary key
#  group_verse_key_from :string
#  group_verse_key_to   :string
#  group_verses_count   :integer
#  hizb_number          :integer
#  juz_number           :integer
#  language_name        :string
#  page_number          :integer
#  resource_name        :string
#  rub_number           :integer
#  text                 :text
#  verse_key            :string
#  verse_number         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  chapter_id           :integer
#  group_tafsir_id      :integer
#  language_id          :integer
#  resource_content_id  :integer
#  verse_id             :integer
#
# Indexes
#
#  index_tafsirs_on_chapter_id                   (chapter_id)
#  index_tafsirs_on_chapter_id_and_verse_number  (chapter_id,verse_number)
#  index_tafsirs_on_hizb_number                  (hizb_number)
#  index_tafsirs_on_juz_number                   (juz_number)
#  index_tafsirs_on_language_id                  (language_id)
#  index_tafsirs_on_page_number                  (page_number)
#  index_tafsirs_on_resource_content_id          (resource_content_id)
#  index_tafsirs_on_rub_number                   (rub_number)
#  index_tafsirs_on_verse_id                     (verse_id)
#  index_tafsirs_on_verse_key                    (verse_key)
#

class Tafsir < ApplicationRecord
  include Resourceable

  belongs_to :verse
  belongs_to :language
  has_many :foot_notes, as: :resource
end
