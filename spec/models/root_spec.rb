# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Root do


  context 'with associations' do
    it { is_expected.to have_many :word_roots }
    it { is_expected.to have_many :words }
    it { is_expected.to have_many :verses }

  end

  context 'with columns and indexes' do
    columns = { value: :string }
    it_behaves_like 'modal with column', columns

  end

end
