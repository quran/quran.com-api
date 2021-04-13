# frozen_string_literal: true

# == Schema Information
#
# Table name: word_roots
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  root_id    :integer
#  word_id    :integer
#
# Indexes
#
#  index_word_roots_on_root_id  (root_id)
#  index_word_roots_on_word_id  (word_id)
#

class WordRoot < ApplicationRecord
  belongs_to :word
  belongs_to :root
end
