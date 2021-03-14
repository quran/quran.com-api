# == Schema Information
#
# Table name: resource_contents
#
#  id                    :integer          not null, primary key
#  approved              :boolean
#  author_name           :string
#  cardinality_type      :string
#  description           :text
#  language_name         :string
#  name                  :string
#  priority              :integer
#  resource_info         :text
#  resource_type         :string
#  slug                  :string
#  sub_type              :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :integer
#  data_source_id        :integer
#  language_id           :integer
#  mobile_translation_id :integer
#
# Indexes
#
#  index_resource_contents_on_approved               (approved)
#  index_resource_contents_on_author_id              (author_id)
#  index_resource_contents_on_cardinality_type       (cardinality_type)
#  index_resource_contents_on_data_source_id         (data_source_id)
#  index_resource_contents_on_language_id            (language_id)
#  index_resource_contents_on_mobile_translation_id  (mobile_translation_id)
#  index_resource_contents_on_priority               (priority)
#  index_resource_contents_on_resource_type          (resource_type)
#  index_resource_contents_on_slug                   (slug)
#  index_resource_contents_on_sub_type               (sub_type)
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
      mobile_translation_id: :integer,
      author_name: :string,
      resource_type: :string,
      sub_type: :string,
      name: :string,
      description: :text,
      cardinality_type: :string,
      language_id: :integer,
      language_name: :string,
      slug: :string,
      priority: :integer
    }

    indexes = [
      ['approved'],
      ['author_id'],
      ['cardinality_type'],
      ['data_source_id'],
      ['language_id'],
      ['resource_type'],
      ['slug'],
      ['sub_type'],
      ['priority']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
