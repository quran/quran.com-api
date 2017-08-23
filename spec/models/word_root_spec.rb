# == Schema Information
#
# Table name: word_roots
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  root_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WordRoot, type: :model do
  describe 'associations' do
    it 'belongs_to word' do
      word = described_class.reflect_on_association(:word)
      expect(word.macro).to eq :belongs_to
    end

    it 'belongs_to root' do
      root = described_class.reflect_on_association(:root)
      expect(root.macro).to eq :belongs_to
    end
  end
end
