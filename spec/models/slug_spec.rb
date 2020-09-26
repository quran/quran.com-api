require 'rails_helper'

RSpec.describe Slug, type: :model do
  context 'with associations' do
    it {
      expect(subject).to belong_to(:chapter)
    }
  end
end
