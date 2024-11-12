# == Schema Information
#
# Table name: authors
#
#  id                      :integer          not null, primary key
#  name                    :string
#  resource_contents_count :integer          default(0)
#  url                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author do
  context 'with associations' do
    it { is_expected.to have_many(:translated_names) }
    it { is_expected.to have_many(:resource_contents) }

    it { is_expected.to have_one(:translated_name) }
  end

  context 'with columns and indexes' do
    it_behaves_like 'modal with column', name: :string, url: :string
  end

  context 'with modules' do
    it { is_expected.to include_module(NameTranslateable) }
  end
end
