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
module Api
  class V3::RecitationSerializer < V3::ApplicationSerializer
    attributes :id, :style, :reciter_name

    has_one :translated_name do
      object.reciter.translated_name
    end
  end
end
