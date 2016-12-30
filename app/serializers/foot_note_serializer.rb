# == Schema Information
#
# Table name: foot_notes
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  text                :text
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class FootNoteSerializer < ActiveModel::Serializer
  attributes :id, :text
  has_one :resource
  has_one :language
  has_one :resource_content
end
