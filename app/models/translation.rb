# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  hizb_number         :integer
#  juz_number          :integer
#  language_name       :string
#  manzil_number       :integer
#  page_number         :integer
#  priority            :integer
#  resource_name       :string
#  rub_el_hizb_number  :integer
#  ruku_number         :integer
#  surah_ruku_number   :integer
#  text                :text
#  verse_key           :string
#  verse_number        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chapter_id          :integer
#  language_id         :integer
#  resource_content_id :integer
#  verse_id            :integer
#
# Indexes
#
#  index_translations_on_chapter_id                   (chapter_id)
#  index_translations_on_chapter_id_and_verse_number  (chapter_id,verse_number)
#  index_translations_on_hizb_number                  (hizb_number)
#  index_translations_on_juz_number                   (juz_number)
#  index_translations_on_language_id                  (language_id)
#  index_translations_on_manzil_number                (manzil_number)
#  index_translations_on_page_number                  (page_number)
#  index_translations_on_priority                     (priority)
#  index_translations_on_resource_content_id          (resource_content_id)
#  index_translations_on_rub_el_hizb_number           (rub_el_hizb_number)
#  index_translations_on_ruku_number                  (ruku_number)
#  index_translations_on_verse_id                     (verse_id)
#  index_translations_on_verse_key                    (verse_key)
#

class Translation < ApplicationRecord
  CLEAN_TEXT_REG = /<sup foot_note="?\d+"?>\d+<\/sup>[\d*\[\]]?/

  include LanguageFilterable
  include Resourceable

  belongs_to :verse
  belongs_to :language
  has_many :foot_notes

  scope :approved, -> { joins(:resource_content).where('resource_contents.approved = ?', true) }

  def clean_text_for_es
    text.gsub(CLEAN_TEXT_REG, '').strip
  end
end
