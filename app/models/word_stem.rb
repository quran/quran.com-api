# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: word_stems
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  stem_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_word_stems_on_stem_id  (stem_id)
#  index_word_stems_on_word_id  (word_id)
#

class WordStem < ApplicationRecord
  belongs_to :word
  belongs_to :stem
end
