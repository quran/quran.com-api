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
require 'rails_helper'

RSpec.describe Audio::RelatedRecitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
