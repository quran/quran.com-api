# frozen_string_literal: true

# == Schema Information
#
# Table name: words
#
#  id                     :integer          not null, primary key
#  audio_url              :string
#  char_type_name         :string
#  class_name             :string
#  code_dec               :integer
#  code_dec_v3            :integer
#  code_hex               :string
#  code_hex_v3            :string
#  code_v1                :string
#  code_v2                :string
#  en_transliteration     :string
#  image_blob             :text
#  image_url              :string
#  line_number            :integer
#  line_v2                :integer
#  location               :string
#  page_number            :integer
#  pause_name             :string
#  position               :integer
#  text_imlaei            :string
#  text_imlaei_simple     :string
#  text_indopak           :string
#  text_nastaleeq_indopak :string
#  text_qpc_hafs          :string
#  text_qpc_nastaleeq     :string
#  text_uthmani           :string
#  text_uthmani_simple    :string
#  text_uthmani_tajweed   :string
#  v2_page                :integer
#  verse_key              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  chapter_id             :integer
#  char_type_id           :integer
#  token_id               :integer
#  topic_id               :integer
#  verse_id               :integer
#
# Indexes
#
#  index_words_on_chapter_id    (chapter_id)
#  index_words_on_char_type_id  (char_type_id)
#  index_words_on_location      (location)
#  index_words_on_position      (position)
#  index_words_on_token_id      (token_id)
#  index_words_on_topic_id      (topic_id)
#  index_words_on_verse_id      (verse_id)
#  index_words_on_verse_key     (verse_key)
#

class Word < ApplicationRecord
  belongs_to :verse
  belongs_to :char_type
  belongs_to :topic
  belongs_to :token

  has_many :transliterations, as: :resource
  has_many :word_translations

  has_many :word_lemmas
  has_many :lemmas, through: :word_lemmas
  has_many :word_stems
  has_many :stems, through: :word_stems
  has_many :word_roots
  has_many :roots, through: :word_roots

  has_one :word_corpus

  # For eager loading
  has_one :word_translation
  has_one :transliteration, -> { where(language_id: 38) }, as: :resource

  default_scope { order 'position asc' }

  alias_attribute :v1_page, :page_number
  #TODO: deprecated and renamed to text_qpc_hafs
  alias_attribute :qpc_uthmani_hafs, :text_qpc_hafs

  def get_page_number(version)
    if :v1 == version
      page_number
    else
      v2_page
    end
  end

  def get_line_number(version)
    if :v1 == version
      line_number
    else
      line_v2
    end
  end

  def get_text(version)
    case version
    when :v1
      code_v1
    when :v2
      code_v2
    when :indopak
      text_indopak
    when :text_qpc_hafs, :qpc_uthmani_hafs
      text_qpc_hafs
    when :uthmani, :uthmani_tajweed
      text_uthmani
    when :imlaei
      text_imlaei
    when :imlaei_simple
      text_imlaei_simple
    when :uthmani_simple
      text_uthmani_simple
    end
  end
end
