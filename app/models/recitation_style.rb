# frozen_string_literal: true

# == Schema Information
#
# Table name: recitation_styles
#
#  id         :integer          not null, primary key
#  style      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RecitationStyle < ApplicationRecord
  include NameTranslateable
end
