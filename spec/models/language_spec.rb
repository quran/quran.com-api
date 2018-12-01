# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  name                :string
#  iso_code            :string
#  native_name         :string
#  direction           :string
#  es_analyzer_default :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language do
  context 'with associations' do
    it { is_expected.to have_many :translated_names }
  end

  context 'with columns and indexes' do
    columns = {
      name: :string,
      iso_code: :string,
      native_name: :string,
      direction: :string,
      es_analyzer_default: :string
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['iso_code']]
  end
end
