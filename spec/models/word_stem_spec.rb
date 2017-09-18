# == Schema Information
#
# Table name: word_stems
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  stem_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WordStem, type: :model do
  describe 'associations' do
    it 'belongs_to word' do
      word = described_class.reflect_on_association(:word)
      expect(word.macro).to eq :belongs_to
    end

    it 'belongs_to stem' do
      stem = described_class.reflect_on_association(:stem)
      expect(stem.macro).to eq :belongs_to
    end
  end
end
