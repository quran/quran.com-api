# frozen_string_literal: true

# == Schema Information
#
# Table name: word_roots
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  root_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WordRoot < ApplicationRecord
  belongs_to :word
  belongs_to :root
end
