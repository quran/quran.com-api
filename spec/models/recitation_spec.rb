# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recitation do
  context "#associations" do
    it { is_expected.to belong_to :reciter }
    it { is_expected.to belong_to :resource_content }
    it { is_expected.to belong_to :recitation_style }
  end

  context "#columns and indexes" do
    columns = {
      reciter_id:          :integer,
      resource_content_id: :integer,
      recitation_style_id: :integer,
      reciter_name:        :string,
      style:               :string
    }

    indexes = [
      ["recitation_style_id"],
      ["reciter_id"],
      ["resource_content_id"]
    ]

    it_behaves_like "modal with column", columns
    it_behaves_like "modal have indexes on column", indexes
  end
end
