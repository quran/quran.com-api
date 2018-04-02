# frozen_string_literal: true

# == Schema Information
#
# Table name: word_corpuses
#
#  id          :integer          not null, primary key
#  word_id     :integer
#  location    :string
#  description :text
#  image_src   :string
#  segments    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe WordCorpus, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
