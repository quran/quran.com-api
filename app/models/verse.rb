# frozen_string_literal: true

# == Schema Information
#
# Table name: verses
#
#  id                     :integer          not null, primary key
#  code_v1                :string
#  code_v2                :string
#  hizb_number            :integer
#  image_url              :text
#  image_width            :integer
#  juz_number             :integer
#  mushaf_pages_mapping   :jsonb
#  page_number            :integer
#  pause_words_count      :integer          default(0)
#  rub_number             :integer
#  sajdah_number          :integer
#  sajdah_type            :string
#  text_imlaei            :string
#  text_imlaei_simple     :string
#  text_indopak           :string
#  text_nastaleeq_indopak :string
#  text_qpc_hafs          :string
#  text_qpc_nastaleeq     :string
#  text_uthmani           :string
#  text_uthmani_simple    :string
#  text_uthmani_tajweed   :text
#  v2_page                :integer
#  verse_index            :integer
#  verse_key              :string
#  verse_number           :integer
#  words_count            :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  chapter_id             :integer
#  verse_lemma_id         :integer
#  verse_root_id          :integer
#  verse_stem_id          :integer
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
#  index_verses_on_words_count     (words_count)
#

class Verse < ApplicationRecord
  include QuranSearchable

  belongs_to :chapter, inverse_of: :verses
  belongs_to :verse_root
  belongs_to :verse_lemma
  belongs_to :verse_stem

  has_many :tafsirs
  has_many :verse_pages
  has_many :words
  has_many :char_words, -> { where char_type_id: 1 }, class_name: 'Word'
  has_many :mushaf_words
  has_many :media_contents, as: :resource
  has_many :translations
  has_many :roots, through: :words
  has_many :audio_files

  # for eager loading one audio
  has_one :audio_file
  has_one :audio_segment, class_name: 'Audio::Segment'

  default_scope { order 'verses.verse_number asc' }

  alias_attribute :v1_page, :page_number
  alias_attribute :verse_id, :id

  def self.find_by_id_or_key(id)
    if id.to_s.include? ':'
      where(verse_key: id).first
    else
      where(verse_key: id).or(where(id: id.to_s)).first
    end
  end

  # QDC api, send page number based on Mushaf
  def get_page_number_for(mushaf:)
    mushaf_pages_mapping[mushaf.to_s]
  end

  def get_page_number(version)
    if :v1 == version
      v1_page
    else
      v2_page
    end
  end

  def get_text(version)
    case version
    when :v1, :code_v1
      code_v1
    when :v2, :code_v2
      code_v2
    when :text_uthmani, :uthmani
      text_uthmani
    when :uthmani_tajweed, :text_uthmani_tajweed
      text_uthmani_tajweed
    when :indopak, :text_indopak
      text_indopak
    when :uthmani_hafs, :qpc_uthmani_hafs, :text_qpc_hafs
      text_qpc_hafs
    end
  end
end
