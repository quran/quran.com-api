# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: reciters
#
#  id                :integer          not null, primary key
#  bio               :text
#  cover_image       :string
#  name              :string
#  profile_picture   :string
#  recitations_count :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  recitations_count :integer          default("0")
#

class Reciter < ApplicationRecord
  include NameTranslateable
end
