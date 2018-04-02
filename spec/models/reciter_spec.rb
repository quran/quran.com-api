# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reciter do
  context "#associations" do
    it { is_expected.to have_many :translated_names }
  end

  context "#columns and indexes" do
    it_behaves_like "modal with column", name: :string
  end
end
