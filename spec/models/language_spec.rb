# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  direction           :string
#  es_analyzer_default :string
#  es_indexes          :string
#  iso_code            :string
#  name                :string
#  native_name         :string
#  translations_count  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_languages_on_iso_code            (iso_code)
#  index_languages_on_translations_count  (translations_count)
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
      es_analyzer_default: :string,
      translations_count: :integer,
      es_indexes: :string
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['iso_code'], ['translations_count']]
  end
end
