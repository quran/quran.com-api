# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lemma do
  context "#associations" do
    it { is_expected.to have_many :word_lemmas }
    it { is_expected.to have_many(:words).through(:word_lemmas) }
    it { is_expected.to have_many(:verses).through(:words) }
  end

  context "#columns and indexes" do
    columns = { text_madani: :string, text_clean: :string }

    it_behaves_like "modal with column", columns
  end
end
