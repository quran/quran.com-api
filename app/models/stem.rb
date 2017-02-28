class Stem < ApplicationRecord
  has_many :word_stems
  has_many :words, through: :word_stems
  has_many :verses, through: :words
end
