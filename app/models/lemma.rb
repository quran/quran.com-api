class Lemma < ApplicationRecord
  has_many :word_lemmas
  has_many :words, through: :word_lemmas
  has_many :verses, through: :words
end
