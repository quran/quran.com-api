# == Schema Information
#
# Table name: media_contents
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  duration            :string
#  embed_text          :text
#  provider            :string
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe MediaContent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
