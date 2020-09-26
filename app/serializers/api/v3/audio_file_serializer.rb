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
#  recitation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module Api
  class V3::AudioFileSerializer < V3::ApplicationSerializer
    attributes :url, :duration, :segments, :format
  end
end