# == Schema Information
#
# Table name: verse_stems
#
#  id          :integer          not null, primary key
#  text_madani :string
#  text_clean  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerseStem do

  context 'with associations' do
    it { is_expected.to have_many :verses }
    it { is_expected.to have_many(:words).through(:verses) }
  end

  context 'with columns and indexes' do
    columns = { text_madani: :string, text_clean: :string }

    it_behaves_like 'modal with column', columns
  end
end
