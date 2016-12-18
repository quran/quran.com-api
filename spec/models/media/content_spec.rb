# == Schema Information
#
# Table name: media.content
#
#  resource_id :integer          not null, primary key
#  ayah_key    :string           primary key
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Media::Content, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
