# frozen_string_literal: true
# == Schema Information
# Schema version: 20220123232023
#
# Table name: reciters
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  recitations_count :integer          default("0")
#  profile_picture   :string
#  cover_image       :string
#  bio               :text
#

class Reciter < ApplicationRecord
  include NameTranslateable
end
