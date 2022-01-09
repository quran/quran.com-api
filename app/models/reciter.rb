# frozen_string_literal: true

# == Schema Information
#
# Table name: reciters
#
#  id                :integer          not null, primary key
#  name              :string
#  recitations_count :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Reciter < ApplicationRecord
  include NameTranslateable
end
