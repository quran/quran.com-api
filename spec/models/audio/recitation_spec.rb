# == Schema Information
#
# Table name: audio_recitations
#
#  id                  :bigint           not null, primary key
#  arabic_name         :string
#  description         :text
#  file_formats        :string
#  files_size          :integer
#  home                :integer
#  name                :string
#  relative_path       :string
#  torrent_filename    :string
#  torrent_info_hash   :string
#  torrent_leechers    :integer          default(0)
#  torrent_seeders     :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  recitation_style_id :integer
#  resource_content_id :integer
#  section_id          :integer
#
# Indexes
#
#  index_audio_recitations_on_recitation_style_id  (recitation_style_id)
#
require 'rails_helper'

RSpec.describe Audio::Recitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
