# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author do
  context 'with associations' do
    it { is_expected.to have_many(:translated_names) }
    it { is_expected.to have_many(:resource_contents) }
  end

  context 'with columns and indexes' do
    it_behaves_like 'modal with column', name: :string, url: :string
  end

end
