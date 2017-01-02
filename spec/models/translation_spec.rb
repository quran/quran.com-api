# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  text                :string
#  resource_content_id :integer
#  resource_type       :string
#  resource_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Translation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
