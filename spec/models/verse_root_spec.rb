# frozen_string_literal: true

require "rails_helper"

RSpec.describe VerseRoot do

  context "#associations" do
    it { is_expected.to have_many :verses }
    it { is_expected.to have_many(:words).through(:verses) }

  end

  context "#columns and indexes" do
    it_behaves_like "modal with column", value: :text
  end

end
