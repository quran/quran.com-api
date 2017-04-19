# == Schema Information
#
# Table name: word_stems
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  stem_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WordStem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
