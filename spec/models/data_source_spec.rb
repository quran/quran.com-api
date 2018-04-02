# frozen_string_literal: true

# == Schema Information
#
# Table name: data_sources
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe DataSource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
