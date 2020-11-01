# == Schema Information
#
# Table name: resource_contents
#
#  id                    :integer          not null, primary key
#  approved              :boolean
#  author_id             :integer
#  data_source_id        :integer
#  author_name           :string
#  resource_type         :string
#  sub_type              :string
#  name                  :string
#  description           :text
#  cardinality_type      :string
#  language_id           :integer
#  language_name         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  mobile_translation_id :integer
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceContent do


  context 'with associations' do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :author }
    it { is_expected.to belong_to :data_source }
  end

  context 'with columns and indexes' do
    columns = {
      approved: :boolean,
      author_id: :integer,
      data_source_id: :integer,
      author_name: :string,
      resource_type: :string,
      sub_type: :string,
      name: :string,
      mobile_translation_id: :integer,
      description: :text,
      cardinality_type: :string,
      language_id: :integer,
      language_name: :string,
      slug: :string
    }

    indexes = [
      ['approved'],
      ['author_id'],
      ['cardinality_type'],
      ['data_source_id'],
      ['language_id'],
      ['resource_type'],
      ['slug'],
      ['sub_type']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
