# == Schema Information
#
# Table name: juzs
#
#  id            :integer          not null, primary key
#  juz_number    :integer
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
      juz_number:    :integer,
      verse_mapping: :json
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['juz_number']]
  end
end
