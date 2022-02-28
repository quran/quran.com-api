# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_related_recitations
#
#  id                          :integer          not null, primary key
#  audio_recitation_id         :integer
#  related_audio_recitation_id :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_audio_related_recitation  (audio_recitation_id,related_audio_recitation_id)
#

class Audio::RelatedRecitation < ApplicationRecord
  belongs_to :audio_recitation, class_name: 'Audio::Recitation'
  belongs_to :related_audio_recitation, class_name: 'Audio::Recitation'
end
