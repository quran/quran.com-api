# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  verse_id            :integer
#  resource_content_id :integer
#  width               :integer
#  url                 :string
#  alt                 :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Image, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
