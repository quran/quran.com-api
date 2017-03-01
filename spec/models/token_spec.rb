# == Schema Information
#
# Table name: tokens
#
#  id              :integer          not null, primary key
#  text_madani     :string
#  text_clean      :string
#  text_indopak    :string
#  transliteration :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Token, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
