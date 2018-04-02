# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaContent do

  context "#associations" do
    it { is_expected.to belong_to :resource }
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource_content }
  end

  context "#columns and indexes" do
    columns = {
      resource_type:       :string,
      resource_id:         :integer,
      url:                 :text,
      duration:            :string,
      embed_text:          :text,
      provider:            :string,
      language_id:         :integer,
      language_name:       :string,
      author_name:         :string,
      resource_content_id: :integer
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
