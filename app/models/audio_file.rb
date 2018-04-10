# frozen_string_literal: true

# == Schema Information
#
# Table name: audio_files
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  url           :text
#  duration      :integer
#  segments      :text
#  mime_type     :string
#  format        :string
#  is_enabled    :boolean
#  recitation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AudioFile < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :recitation

  serialize :segments, Array
end
