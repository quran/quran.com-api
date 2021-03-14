# frozen_string_literal: true

# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_name        :string
#  style               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  recitation_style_id :integer
#  reciter_id          :integer
#  resource_content_id :integer
#
# Indexes
#
#  index_recitations_on_recitation_style_id  (recitation_style_id)
#  index_recitations_on_reciter_id           (reciter_id)
#  index_recitations_on_resource_content_id  (resource_content_id)
#

class Recitation < ApplicationRecord
  include Resourceable

  belongs_to :reciter
  belongs_to :recitation_style

  scope :approved, -> { joins(:resource_content).where('resource_contents.approved = ?', true) }
end
