# frozen_string_literal: true

# == Schema Information
#
# Table name: lemmas
#
#  id          :integer          not null, primary key
#  text_madani :string
#  text_clean  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Lemma < ApplicationRecord
  has_many :word_lemmas
  has_many :words, through: :word_lemmas
  has_many :verses, through: :words
end
