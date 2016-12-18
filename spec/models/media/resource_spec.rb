# == Schema Information
#
# Table name: media.resource
#
#  resource_id :integer          not null, primary key
#  name        :string
#  url         :string
#  provider    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Media::Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
