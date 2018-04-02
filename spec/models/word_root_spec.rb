# frozen_string_literal: true

# == Schema Information
#
# Table name: word_roots
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  root_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe WordRoot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
