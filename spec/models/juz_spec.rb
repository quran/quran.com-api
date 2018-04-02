# frozen_string_literal: true

require "rails_helper"

RSpec.describe Juz do
  context "#associations" do
    it { is_expected.to have_many(:verses).with_foreign_key(:juz_number) }
    it { is_expected.to have_many(:chapters).through(:verses) }

    it { should serialize(:verse_mapping).as(Hash) }
  end

  context "#columns and indexes" do
    columns = {
      juz_number:    :integer,
      name_simple:   :string,
      name_arabic:   :string,
      verse_mapping: :json
    }

    it_behaves_like "modal with column", columns
    it_behaves_like "modal have indexes on column", [["juz_number"]]
  end
end
