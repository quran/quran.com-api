# frozen_string_literal: true
# == Schema Information
# Schema version: 20220123232023
#
# Table name: word_stems
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stem_id    :integer
#  word_id    :integer
#
# Indexes
#
#  index_word_stems_on_stem_id  (stem_id)
#  index_word_stems_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_24cfb9fc97  (word_id => words.id)
#  fk_rails_d7975076d8  (stem_id => stems.id)
#

class WordStem < ApplicationRecord
  belongs_to :word
  belongs_to :stem
end
