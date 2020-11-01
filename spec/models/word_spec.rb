# == Schema Information
#
# Table name: words
#
#  id             :integer          not null, primary key
#  verse_id       :integer
#  chapter_id     :integer
#  position       :integer
#  text_madani    :text
#  text_indopak   :text
#  text_simple    :text
#  text_imlaei    :text
#  verse_key      :string
#  page_number    :integer
#  class_name     :string
#  line_number    :integer
#  code_dec       :integer
#  code_hex       :string
#  code_hex_v3    :string
#  code_dec_v3    :integer
#  char_type_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pause_name     :string
#  audio_url      :string
#  image_blob     :text
#  image_url      :string
#  token_id       :integer
#  topic_id       :integer
#  location       :string
#  char_type_name :string
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Word do

  context 'with associations' do
    it { is_expected.to belong_to :verse }
    it { is_expected.to belong_to :char_type }
    it { is_expected.to belong_to :topic }
    it { is_expected.to belong_to :token }
    it { is_expected.to have_one(:audio).class_name('AudioFile') }
    it { is_expected.to have_one :word_corpus }
    it { is_expected.to have_many :translations }
    it { is_expected.to have_many :transliterations }
    it { is_expected.to have_many :word_lemmas }
    it { is_expected.to have_many :lemmas }
    it { is_expected.to have_many :word_stems }
    it { is_expected.to have_many :stems }
    it { is_expected.to have_many :word_roots }
    it { is_expected.to have_many :roots }

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
      text_madani: :text,
      text_indopak: :text,
      text_simple: :text,
      text_imlaei: :text,
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
      char_type_name: :string
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
