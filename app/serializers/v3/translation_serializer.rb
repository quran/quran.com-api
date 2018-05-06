# frozen_string_literal: true

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
  attributes :id, :language_name, :text, :resource_name
  attribute :resource_content_id, key: :resource_id
end
