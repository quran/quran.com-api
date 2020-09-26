require 'rails_helper'

RSpec.describe WordTranslation, type: :model do
  context 'with associations' do
    it {
      expect(subject).to belong_to(:word)
    }
    it {
      expect(subject).to belong_to(:language)
    }
    it {
      expect(subject).to belong_to(:resource_content)
    }
  end
end
