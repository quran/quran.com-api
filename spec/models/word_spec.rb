# == Schema Information
#
# Table name: words
#
#  id                      :integer          not null, primary key
#  audio_url               :string
#  char_type_name          :string
#  class_name              :string
#  code_dec                :integer
#  code_dec_v3             :integer
#  code_hex                :string
#  code_hex_v3             :string
#  code_v1                 :string
#  code_v2                 :string
#  en_transliteration      :string
#  image_blob              :text
#  image_url               :string
#  line_number             :integer
#  line_v2                 :integer
#  location                :string
#  page_number             :integer
#  pause_name              :string
#  position                :integer
#  text_imlaei             :string
#  text_imlaei_simple      :string
#  text_indopak            :string
#  text_indopak_nastaleeq  :string
#  text_qpc_hafs           :string
#  text_qpc_nastaleeq      :string
#  text_qpc_nastaleeq_hafs :string
#  text_uthmani            :string
#  text_uthmani_simple     :string
#  text_uthmani_tajweed    :string
#  v2_page                 :integer
#  verse_key               :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  chapter_id              :integer
#  char_type_id            :integer
#  token_id                :integer
#  topic_id                :integer
#  verse_id                :integer
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

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Word do
  context 'with associations' do
    it { is_expected.to belong_to :verse }
    it { is_expected.to belong_to :char_type }
    it { is_expected.to belong_to :topic }
    it { is_expected.to belong_to :token }
    it { is_expected.to have_one :word_corpus }
    it { is_expected.to have_many :transliterations }
    it { is_expected.to have_many :word_lemmas }
    it { is_expected.to have_many :lemmas }
    it { is_expected.to have_many :word_stems }
    it { is_expected.to have_many :stems }
    it { is_expected.to have_many :word_roots }
    it { is_expected.to have_many :roots }
    it { is_expected.to have_many :word_translations }
    it { is_expected.to have_one :word_translation }

    it 'orders by position' do
      expect(described_class.default_scoped.to_sql)
        .to include('ORDER BY position asc')
    end
  end

  context 'with columns and indexes' do
    columns = {
      verse_id: :integer,
      chapter_id: :integer,
      position: :integer,
      text_uthmani: :string,
      text_uthmani_simple: :string,
      text_uthmani_tajweed: :string,
      text_imlaei: :string,
      text_imlaei_simple: :string,
      text_indopak: :string,
      verse_key: :string,
      page_number: :integer,
      class_name: :string,
      line_number: :integer,
      code_dec: :integer,
      code_hex: :string,
      code_hex_v3: :string,
      code_dec_v3: :integer,
      char_type_id: :integer,
      pause_name: :string,
      audio_url: :string,
      token_id: :integer,
      topic_id: :integer,
      location: :string,
      en_transliteration: :string,
      char_type_name: :string,
      image_blob: :text,
      image_url: :string
    }

    indexes = [
      ['chapter_id'],
      ['char_type_id'],
      ['location'],
      ['position'],
      ['token_id'],
      ['topic_id'],
      ['verse_id'],
      ['verse_key']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
