# == Schema Information
#
# Table name: audio_change_logs
#
#  id                  :bigint           not null, primary key
#  date                :datetime
#  mini_desc           :text
#  rss_desc            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  audio_recitation_id :integer
#
require 'rails_helper'

RSpec.describe Audio::ChangeLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
