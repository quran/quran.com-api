# == Schema Information
#
# Table name: word_lemmas
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  lemma_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WordLemma, type: :model do
  describe 'associations' do
    it 'belongs_to word' do
      word = described_class.reflect_on_association(:word)
      expect(word.macro).to eq :belongs_to
    end

    it 'belongs_to lemma' do
      lemma = described_class.reflect_on_association(:lemma)
      expect(lemma.macro).to eq :belongs_to
    end
  end
end
