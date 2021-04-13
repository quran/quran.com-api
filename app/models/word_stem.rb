# frozen_string_literal: true

# == Schema Information
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
#  fk_rails_...  (stem_id => stems.id)
#  fk_rails_...  (word_id => words.id)
#

class WordStem < ApplicationRecord
  belongs_to :word
  belongs_to :stem
end
