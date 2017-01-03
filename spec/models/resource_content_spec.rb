# == Schema Information
#
# Table name: resource_contents
#
#  id               :integer          not null, primary key
#  approved         :boolean
#  author_id        :integer
#  data_source_id   :integer
#  author_name      :string
#  resource_type    :string
#  sub_type         :string
#  name             :string
#  description      :text
#  cardinality_type :string
#  language_id      :integer
#  language_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ResourceContent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
