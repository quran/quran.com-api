# frozen_string_literal: true

# == Schema Information
#
# Table name: audio_related_recitations
#
#  id                          :bigint           not null, primary key
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  audio_recitation_id         :integer
#  related_audio_recitation_id :integer
#
# Indexes
#
#  index_audio_related_recitation  (audio_recitation_id,related_audio_recitation_id)
#
class Audio::RelatedRecitation < ApplicationRecord
  belongs_to :audio_recitation, class_name: 'Audio::Recitation'
  belongs_to :related_audio_recitation, class_name: 'Audio::Recitation'
end
