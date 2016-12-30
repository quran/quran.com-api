# == Schema Information
#
# Table name: media_contents
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  embed_text          :text
#  provider            :string
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class MediaContentSerializer < ActiveModel::Serializer
  attributes :id, :url, :embed_text, :provider
  has_one :resource
  has_one :language
  has_one :resource_content
end
