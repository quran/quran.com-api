# frozen_string_literal: true

# == Schema Information
#
# Table name: stems
#
#  id          :integer          not null, primary key
#  text_madani :string
#  text_clean  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Stem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
