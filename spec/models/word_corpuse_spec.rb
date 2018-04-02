# frozen_string_literal: true

require "rails_helper"

RSpec.describe WordCorpus do
  context "#associations" do
    it { is_expected.to belong_to :word }
  end

  context "#columns and indexes" do
    columns = {
      word_id: :integer,
      location: :string,
      description: :text,
      image_src: :string,
      segments: :json
    }

    it_behaves_like "modal with column", columns
    it_behaves_like "modal have indexes on column", [["word_id"]]
  end
end
