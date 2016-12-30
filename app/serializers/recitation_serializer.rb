# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_id          :integer
#  resource_type       :string
#  resource_id         :integer
#  resource_content_id :integer
#  recitation_style_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class RecitationSerializer < ActiveModel::Serializer
  attributes :id
  has_one :reciter
  has_one :resource
  has_one :resource_content
  has_one :recition_style
end
