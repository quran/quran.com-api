# frozen_string_literal: true

# == Schema Information
#
# Table name: verse_lemmas
#
#  id          :integer          not null, primary key
#  text_madani :string
#  text_clean  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class VerseLemma < ApplicationRecord
  has_many :verses
  has_many :words, through: :verses
end
