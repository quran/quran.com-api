# frozen_string_literal: true

# == Schema Information
#
# Table name: lemmas
#
#  id               :integer          not null, primary key
#  text_clean       :string
#  text_madani      :string
#  uniq_words_count :integer
#  words_count      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Lemma < ApplicationRecord
  has_many :word_lemmas
  has_many :words, through: :word_lemmas
  has_many :verses, through: :words
end
