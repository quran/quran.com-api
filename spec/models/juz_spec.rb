# == Schema Information
#
# Table name: juzs
#
#  id            :integer          not null, primary key
#  juz_number    :integer
#  name_simple   :string
#  name_arabic   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  verse_mapping :json
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Juz do
  context 'with associations' do
    it { is_expected.to have_many(:verses).with_foreign_key(:juz_number) }
    it { is_expected.to have_many(:chapters).through(:verses) }

    it { is_expected.to serialize(:verse_mapping).as(Hash) }
  end

  context 'with columns and indexes' do
    columns = {
      juz_number: :integer,
      verse_mapping: :json
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['juz_number']]
  end

  context '#elastic search' do
    it 'has an index' do
      expect(described_class.index_name).to eq('chapters')
    end

    it 'respond to ES methods' do
      expect(described_class).to respond_to(:mappings)
      expect(described_class.new).to respond_to(:es_mappings)
      expect(described_class.new).to respond_to(:as_indexed_json)
    end
  end
end
