# frozen_string_literal: true

# == Schema Information
#
# Table name: stems
#
#  id          :integer          not null, primary key
#  text_madani :string
#  text_clean  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Stem < ApplicationRecord
  has_many :word_stems
  has_many :words, through: :word_stems
  has_many :verses, through: :words
end
