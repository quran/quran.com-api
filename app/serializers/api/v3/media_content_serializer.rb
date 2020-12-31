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
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Api
  class V3::MediaContentSerializer < V3::ApplicationSerializer
    attributes :url, :embed_text, :provider, :author_name
  end
end
