# == Schema Information
#
# Table name: reciters
#
#  id                :integer          not null, primary key
#  name              :string
#  recitations_count :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reciter do
  context 'with associations' do
    it { is_expected.to have_many :translated_names }
  end

  context 'with columns and indexes' do
    it_behaves_like 'modal with column', name: :string
  end
end
