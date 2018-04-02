# frozen_string_literal: true

# == Schema Information
#
# Table name: char_types
#
#  id          :integer          not null, primary key
#  name        :string
#  parent_id   :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe CharType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
