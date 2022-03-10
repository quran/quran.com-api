# frozen_string_literal: true
# == Schema Information
# Schema version: 20220123232023
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
#  fk_rails_af367088a5  (word_id => words.id)
#  fk_rails_cf1f59048d  (lemma_id => lemmas.id)
#

class WordLemma < ApplicationRecord
  belongs_to :word
  belongs_to :lemma
end
