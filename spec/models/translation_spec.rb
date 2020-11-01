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
#  priority         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_name       :string
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  context 'with associations' do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource }
    it { is_expected.to belong_to :resource_content }

    it { is_expected.to have_many :foot_notes }
  end

  context 'with columns and indexes' do
    columns = {
      language_id: :integer,
      text: :string,
      resource_content_id: :integer,
      resource_type: :string,
      resource_id: :integer,
      priority: :integer,
      language_name: :string,
      resource_name: :string
    }

    indexes = [
      ['language_id'],
      ['resource_content_id'],
      ['resource_type', 'resource_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
