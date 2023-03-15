# frozen_string_literal: true

# == Schema Information
# Schema version: 20230313013539
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
#  index_media_contents_on_language_id          (language_id)
#  index_media_contents_on_resource             (resource_type,resource_id)
#  index_media_contents_on_resource_content_id  (resource_content_id)
#

class MediaContent < ApplicationRecord
  include Resourceable

  belongs_to :resource, polymorphic: true
  belongs_to :language
end
