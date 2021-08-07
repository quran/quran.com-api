# == Schema Information
#
# Table name: qirat_types
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe QiratType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
