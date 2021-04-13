# == Schema Information
#
# Table name: word_lemmas
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lemma_id   :integer
#  word_id    :integer
#
# Indexes
#
#  index_word_lemmas_on_lemma_id  (lemma_id)
#  index_word_lemmas_on_word_id   (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (lemma_id => lemmas.id)
#  fk_rails_...  (word_id => words.id)
#

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
