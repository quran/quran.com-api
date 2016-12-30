# == Schema Information
#
# Table name: tafsirs
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  language_id         :integer
#  text                :text
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class TafsirSerializer < ActiveModel::Serializer
  attributes :id, :text
  has_one :resource
  has_one :language
  has_one :resource_content
end
