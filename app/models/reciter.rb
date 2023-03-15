# frozen_string_literal: true
# == Schema Information
# Schema version: 20230313013539
#
# Table name: reciters
#
#  id                :integer          not null, primary key
#  bio               :text
#  cover_image       :string
#  description       :text
#  name              :string
#  profile_picture   :string
#  recitations_count :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Reciter < ApplicationRecord
  include NameTranslateable
end
