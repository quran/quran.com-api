# == Schema Information
#
# Table name: foot_notes
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  text                :text
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe FootNote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
