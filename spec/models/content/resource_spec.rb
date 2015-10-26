# == Schema Information
#
# Table name: content.resource
#
#  resource_id      :integer          not null, primary key
#  type             :text             not null
#  sub_type         :text             not null
#  cardinality_type :text             default("1_ayah"), not null
#  language_code    :text             not null
#  slug             :text             not null
#  is_available     :boolean          default(TRUE), not null
#  description      :text
#  author_id        :integer
#  source_id        :integer
#  name             :text             not null
#

require 'rails_helper'

RSpec.describe Content::Resource, type: :model do
  it "should return arrays" do
  end
end
