# == Schema Information
#
# Table name: transliterations
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  language_id         :integer
#  text                :text
#  language_name       :string
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transliteration do

  context 'with associations' do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource }
    it { is_expected.to belong_to :resource_content }
  end

  context 'with columns and indexes' do
    columns = {
      resource_type: :string,
      resource_id: :integer,
      language_id: :integer,
      text: :text,
      language_name: :string,
      resource_content_id: :integer
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
