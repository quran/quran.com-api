# frozen_string_literal: true

# == Schema Information
#
# Table name: word_corpuses
#
#  id          :integer          not null, primary key
#  word_id     :integer
#  location    :string
#  description :text
#  image_src   :string
#  segments    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WordCorpus < ApplicationRecord
  self.table_name = :word_corpuses

  belongs_to :word
end
