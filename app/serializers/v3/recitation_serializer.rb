# frozen_string_literal: true

# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_id          :integer
#  resource_content_id :integer
#  recitation_style_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::RecitationSerializer < V3::ApplicationSerializer
  attributes :id, :style

  attribute :reciter_name_eng do
    object.reciter_name
  end

  # TODO: better name ? maybe reciter_name: {english: 'eng version', lang: 'lang specific name'}
  attribute :reciter_name_translated, if: :include_translated_name? do
    object.reciter.translated_names.filter_by_language_or_default(scope[:language]).name
  end

  def include_translated_name?
    scope[:language]
  end
end
