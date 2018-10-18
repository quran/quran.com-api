# frozen_string_literal: true

# == Schema Information
#
# Table name: media_contents
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  duration            :string
#  embed_text          :text
#  provider            :string
#  language_id         :integer
#  language_name       :string
#  author_name         :string
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class MediaContent < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :language
  belongs_to :resource_content
end
