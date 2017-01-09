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
  attributes :language_name, :text
  attribute :author_name do
    object.resource_content&.author_name
  end
end
