# == Schema Information
#
# Table name: media_contents
#
#  id                  :integer          not null, primary key
#  author_name         :string
#  duration            :string
#  embed_text          :text
#  language_name       :string
#  provider            :string
#  resource_type       :string
#  url                 :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  language_id         :integer
#  resource_content_id :integer
#  resource_id         :integer
#
# Indexes
#
#  index_media_contents_on_language_id                    (language_id)
#  index_media_contents_on_resource_content_id            (resource_content_id)
#  index_media_contents_on_resource_type_and_resource_id  (resource_type,resource_id)
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaContent do
  context 'with associations' do
    it { is_expected.to belong_to :resource }
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource_content }
  end

  context 'with columns and indexes' do
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
      ['language_id'],
      ['resource_content_id'],
      ['resource_type', 'resource_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
