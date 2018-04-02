# frozen_string_literal: true

# == Schema Information
#
# Table name: word_lemmas
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  lemma_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe WordLemma, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
