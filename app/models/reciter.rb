# frozen_string_literal: true

# == Schema Information
#
# Table name: reciters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reciter < ApplicationRecord
  has_many :translated_names, as: :resource
end
