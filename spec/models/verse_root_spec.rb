# == Schema Information
#
# Table name: verse_roots
#
#  id         :integer          not null, primary key
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerseRoot do
  context 'with associations' do
    it { is_expected.to have_many :verses }
    it { is_expected.to have_many(:words).through(:verses) }
  end

  context 'with columns and indexes' do
    it_behaves_like 'modal with column', value: :text
  end
end
