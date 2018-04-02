# frozen_string_literal: true

# == Schema Information
#
# Table name: translated_names
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  language_id   :integer
#  name          :string
#  language_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe TranslatedName, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
