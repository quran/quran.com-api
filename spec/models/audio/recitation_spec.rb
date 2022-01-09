# == Schema Information
#
# Table name: audio_recitations
#
#  id                  :bigint           not null, primary key
#  approved            :boolean
#  arabic_name         :string
#  description         :text
#  files_count         :integer
#  files_size          :integer
#  format              :string
#  home                :integer
#  name                :string
#  priority            :integer
#  relative_path       :string
#  segment_locked      :boolean          default(FALSE)
#  segments_count      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  qirat_type_id       :integer
#  recitation_style_id :integer
#  reciter_id          :integer
#  resource_content_id :integer
#  section_id          :integer
#
# Indexes
#
#  index_audio_recitations_on_approved             (approved)
#  index_audio_recitations_on_name                 (name)
#  index_audio_recitations_on_priority             (priority)
#  index_audio_recitations_on_recitation_style_id  (recitation_style_id)
#  index_audio_recitations_on_reciter_id           (reciter_id)
#  index_audio_recitations_on_relative_path        (relative_path)
#  index_audio_recitations_on_resource_content_id  (resource_content_id)
#  index_audio_recitations_on_section_id           (section_id)
#
require 'rails_helper'

RSpec.describe Audio::Recitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
