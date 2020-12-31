# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  text                :string
#  resource_content_id :integer
#  resource_type       :string
#  resource_id         :integer
#  language_name       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_name       :string
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  context 'with associations' do
    it { is_expected.to belong_to(:language) }
    it { is_expected.to belong_to(:verse) }
    it { is_expected.to belong_to(:resource_content) }
    it { is_expected.to have_many(:foot_notes) }
  end

  context 'methods' do
    it { expect(described_class).to respond_to(:approved) }
    it { expect(described_class).to respond_to(:filter_by_language_or_default) }
  end

  context 'with columns and indexes' do
    columns = {
      language_id: :integer,
      text: :text,
      resource_content_id: :integer,
      verse_id: :integer,
      language_name: :string,
      resource_name: :string,
      priority: :integer
    }

    indexes = [
      ['language_id'],
      ['resource_content_id'],
      ['verse_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
