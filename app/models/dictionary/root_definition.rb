# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: dictionary_root_definitions
#
#  id              :integer          not null, primary key
#  definition_type :integer
#  description     :text
#  word_root_id    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_dict_word_definition  (word_root_id)
#

class Dictionary::RootDefinition < ApplicationRecord
  enum definition_type: {
    literal: 1,
    regular: 2
  }

  belongs_to :word_root, class_name: 'Dictionary::WordRoot'
end
