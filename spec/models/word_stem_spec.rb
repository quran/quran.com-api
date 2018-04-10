# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WordStem do

  context 'with associations' do
    it { is_expected.to belong_to :word }
    it { is_expected.to belong_to :stem }
  end

  context 'with columns and indexes' do
    columns = {
      word_id: :integer,
      stem_id: :integer
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['stem_id'], ['word_id']]
  end
end
