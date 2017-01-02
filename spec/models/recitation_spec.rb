# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_id          :integer
#  resource_content_id :integer
#  recitation_style_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Recitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
