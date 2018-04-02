# frozen_string_literal: true

RSpec.shared_examples "modal have indexes on column" do |indexes|
  indexes.each do |columns|
    it { is_expected.to have_db_index(columns) }
  end
end
