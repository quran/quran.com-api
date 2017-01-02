# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  text                :string
#  resource_content_id :integer
#  resource_type       :string
#  resource_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::TranslationSerializer < V3::ApplicationSerializer
  attributes :id, :text
  has_one :resource
  has_one :language
  has_one :resource_content
end
