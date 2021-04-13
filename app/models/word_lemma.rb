# frozen_string_literal: true

# == Schema Information
#
# Table name: word_lemmas
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lemma_id   :integer
#  word_id    :integer
#
# Indexes
#
#  index_word_lemmas_on_lemma_id  (lemma_id)
#  index_word_lemmas_on_word_id   (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (lemma_id => lemmas.id)
#  fk_rails_...  (word_id => words.id)
#

class WordLemma < ApplicationRecord
  belongs_to :word
  belongs_to :lemma
end
