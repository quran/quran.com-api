# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChapterInfo do
  context 'with associations' do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :chapter }
    it { is_expected.to belong_to :resource_content }
  end

  context 'with columns and indexes' do
    columns = {
      chapter_id:          :integer,
      text:                :text,
      source:              :string,
      short_text:          :text,
      language_id:         :integer,
      resource_content_id: :integer,
      language_name:       :string
    }

    indexes = [
      ['chapter_id'],
      ['language_id'],
      ['resource_content_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
