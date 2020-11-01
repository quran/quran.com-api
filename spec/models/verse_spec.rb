# == Schema Information
#
# Table name: verses
#
#  id             :integer          not null, primary key
#  chapter_id     :integer
#  verse_number   :integer
#  verse_index    :integer
#  verse_key      :string
#  text_madani    :text
#  text_indopak   :text
#  text_simple    :text
#  text_imlaei    :text
#  juz_number     :integer
#  hizb_number    :integer
#  rub_number     :integer
#  sajdah         :string
#  sajdah_number  :integer
#  page_number    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image_url      :text
#  image_width    :integer
#  verse_root_id  :integer
#  verse_lemma_id :integer
#  verse_stem_id  :integer
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Verse do

  context 'with associations' do
    it {
      is_expected.to belong_to(:chapter)
                       .counter_cache(true)
                       .inverse_of(:verses)
    }
    it { is_expected.to belong_to :verse_root }
    it { is_expected.to belong_to :verse_lemma }
    it { is_expected.to belong_to :verse_stem }

    it { is_expected.to have_many :tafsirs }
    it { is_expected.to have_many :words }
    it { is_expected.to have_many :media_contents }
    it { is_expected.to have_many :translations }
    it { is_expected.to have_many :transliterations }
    it { is_expected.to have_many :audio_files }
    it { is_expected.to have_many :recitations }
    it { is_expected.to have_many(:roots).through(:words) }
  end

  context 'with columns and indexes' do
    columns = {
      chapter_id:     :integer,
      verse_number:   :integer,
      verse_index:    :integer,
      verse_key:      :string,
      text_madani:    :text,
      text_indopak:   :text,
      text_imlaei:    :text,
      text_simple:    :text,
      juz_number:     :integer,
      hizb_number:    :integer,
      rub_number:     :integer,
      sajdah:         :string,
      sajdah_number:  :integer,
      page_number:    :integer,
      image_url:      :text,
      image_width:    :integer,
      verse_root_id:  :integer,
      verse_lemma_id: :integer,
      verse_stem_id:  :integer
    }

    indexes = [
      ['chapter_id'],
      ['verse_index'],
      ['verse_key'],
      ['verse_lemma_id'],
      ['verse_number'],
      ['verse_root_id'],
      ['verse_stem_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end

end
