# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_change_logs
#
#  id                  :integer          not null, primary key
#  audio_recitation_id :integer
#  date                :datetime
#  mini_desc           :text
#  rss_desc            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Audio::ChangeLog < ApplicationRecord
  belongs_to :audio_recitation, class_name: 'Audio::Recitation', optional: true
end
