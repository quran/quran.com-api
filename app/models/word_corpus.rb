# frozen_string_literal: true

# == Schema Information
#
# Table name: word_corpuses
#
#  id            :integer          not null, primary key
#  description   :text
#  image_src     :string
#  location      :string
#  segments      :json
#  segments_data :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  word_id       :integer
#
# Indexes
#
#  index_word_corpuses_on_word_id  (word_id)
#

class WordCorpus < ApplicationRecord
  self.table_name = 'word_corpuses'
  belongs_to :word
end
