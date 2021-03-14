# == Schema Information
#
# Table name: word_translations
#
#  id                  :bigint           not null, primary key
#  language_name       :string
#  priority            :integer
#  text                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  language_id         :integer
#  resource_content_id :integer
#  word_id             :integer
#
# Indexes
#
#  index_word_translations_on_priority                 (priority)
#  index_word_translations_on_word_id_and_language_id  (word_id,language_id)
#
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
