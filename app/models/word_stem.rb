# frozen_string_literal: true

# == Schema Information
#
# Table name: word_stems
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  stem_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WordStem < ApplicationRecord
  belongs_to :word
  belongs_to :stem
end
