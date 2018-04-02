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

require "rails_helper"

RSpec.describe AudioFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
