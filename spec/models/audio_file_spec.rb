# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioFile, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:verse) }
    it { is_expected.to belong_to(:recitation) }
    it { is_expected.to serialize(:segments).as(Array) }
  end

  context 'with columns and indexes' do
    columns = {
      verse_id:   :integer,
      url:           :text,
      duration:      :integer,
      segments:      :text,
      mime_type:     :string,
      format:        :string,
      is_enabled:    :boolean,
      recitation_id: :integer,
      hizb_number:        :integer,
      juz_number:        :integer,
      manzil_number:      :integer,
      page_number:        :integer,
      rub_el_hizb_number: :integer,
      ruku_number:        :integer,
      surah_ruku_number:  :integer,
      verse_key:          :string,
      verse_number:       :integer,
      chapter_id:         :integer
    }

    indexes = [
      'is_enabled',
      'recitation_id',
      'verse_id',
      'hizb_number',
      'chapter_id',
      'manzil_number',
      'page_number',
      'rub_el_hizb_number',
      'ruku_number',
      'verse_id',
      'verse_key',
      ['chapter_id', 'verse_number']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
