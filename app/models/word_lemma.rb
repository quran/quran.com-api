# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: word_lemmas
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  lemma_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_word_lemmas_on_lemma_id  (lemma_id)
#  index_word_lemmas_on_word_id   (word_id)
#

class WordLemma < ApplicationRecord
  belongs_to :word
  belongs_to :lemma
end
