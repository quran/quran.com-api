# frozen_string_literal: true

# == Schema Information
#
# Table name: translated_names
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  language_id   :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class V3::TranslatedNameSerializer < V3::ApplicationSerializer
  attributes :language_name, :name
end
