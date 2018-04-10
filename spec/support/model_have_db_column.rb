# frozen_string_literal: true

RSpec.shared_examples 'modal with column' do |columns|
  columns.each_pair do |column, type|
    it { is_expected.to have_db_column(column).of_type(type) }
  end

  it {
    # We're not testing three standard columns: id, created_at and updated_at
    expect(described_class.column_names.size).to eq(columns.size + 3)
  }
end
