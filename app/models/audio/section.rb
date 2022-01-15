# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_sections
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Audio::Section < ApplicationRecord
  include NameTranslateable
end
