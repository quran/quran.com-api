# frozen_string_literal: true

require "rails_helper"

RSpec.describe Translation do
  context "#associations" do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource }
    it { is_expected.to belong_to :resource_content }

    it { is_expected.to have_many :foot_notes }
  end

  context "#columns and indexes" do
    columns = {
      language_id: :integer,
      text: :string,
      resource_content_id: :integer,
      resource_type: :string,
      resource_id: :integer,
      language_name: :string,
      resource_name: :string
    }

    indexes = [
      ["language_id"],
      ["resource_content_id"],
      ["resource_type", "resource_id"]
    ]

    it_behaves_like "modal with column", columns
    it_behaves_like "modal have indexes on column", indexes
  end
end
