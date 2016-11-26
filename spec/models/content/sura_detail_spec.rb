# == Schema Information
#
# Table name: content.surah_details
#
#  id            :integer          not null
#  language_code :string
#  description   :text
#  surah_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Content::SuraDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
