# frozen_string_literal: true

# == Schema Information
#
# Table name: verses
#
#  id                   :integer          not null, primary key
#  code_v1              :string
#  code_v2              :string
#  hizb_number          :integer
#  image_url            :text
#  image_width          :integer
#  juz_number           :integer
#  page_number          :integer
#  rub_number           :integer
#  sajdah_number        :integer
#  sajdah_type          :string
#  text_imlaei          :string
#  text_imlaei_simple   :string
#  text_indopak         :string
#  text_uthmani         :string
#  text_uthmani_simple  :string
#  text_uthmani_tajweed :text
#  v2_page              :integer
#  verse_index          :integer
#  verse_key            :string
#  verse_number         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  chapter_id           :integer
#  verse_lemma_id       :integer
#  verse_root_id        :integer
#  verse_stem_id        :integer
#
# Indexes
#
#  index_verses_on_chapter_id      (chapter_id)
#  index_verses_on_verse_index     (verse_index)
#  index_verses_on_verse_key       (verse_key)
#  index_verses_on_verse_lemma_id  (verse_lemma_id)
#  index_verses_on_verse_number    (verse_number)
#  index_verses_on_verse_root_id   (verse_root_id)
#  index_verses_on_verse_stem_id   (verse_stem_id)
#

class Verse < ApplicationRecord
  attr_accessor :highlighted_text
  include QuranSearchable

  belongs_to :chapter, inverse_of: :verses
  belongs_to :verse_root
  belongs_to :verse_lemma
  belongs_to :verse_stem

  has_many :tafsirs
  has_many :words
  has_many :media_contents, as: :resource
  has_many :translations
  has_many :roots, through: :words
  has_many :audio_files
  # for eager loading one audio
  has_one :audio_file

  default_scope { order 'verses.verse_number asc' }

  alias_attribute :v1_page, :page_number

  def self.find_by_id_or_key(id)
    where(verse_key: id).or(where(id: id)).first
  end
end
