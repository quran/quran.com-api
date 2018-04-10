# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WordLemma do
  context 'with associations' do
    it { is_expected.to belong_to :word }
    it { is_expected.to belong_to :lemma }
  end

  context 'with columns and indexes' do
    columns = { word_id: :integer, lemma_id: :integer }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['lemma_id'], ['word_id']]
  end
end
