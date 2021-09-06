# == Schema Information
#
# Table name: lemmas
#
#  id          :integer          not null, primary key
#  text_clean  :string
#  text_madani :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lemma do
  context 'with associations' do
    it { is_expected.to have_many :word_lemmas }
    it { is_expected.to have_many(:words).through(:word_lemmas) }
    it { is_expected.to have_many(:verses).through(:words) }
  end

  context 'with columns and indexes' do
    columns = { text_madani: :string, text_clean: :string }

    it_behaves_like 'modal with column', columns
  end
end
