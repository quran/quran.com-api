# frozen_string_literal: true

require "rails_helper"

RSpec.describe Topic do
  context "#associations" do
    it { is_expected.to belong_to(:parent).class_name("Topic") }
    it {
      is_expected.to belong_to(:children)
                       .class_name("Topic")
                       .with_foreign_key("parent_id")
    }

    it { is_expected.to have_many :words }
    it { is_expected.to have_many(:verses).through(:words) }
  end

  context "#columns and indexes" do
    columns = { name: :string, parent_id: :integer }

    it_behaves_like "modal with column", columns
    it_behaves_like "modal have indexes on column", [["parent_id"]]
  end
end
