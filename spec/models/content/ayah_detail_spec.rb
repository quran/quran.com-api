# == Schema Information
#
# Table name: ayah_detail
#
#  ayah_detail_id       :integer          not null, primary key
#  language_code        :string
#  description          :text
#  name                 :text
#  theme                :text
#  period_of_revelation :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Content::AyahDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
