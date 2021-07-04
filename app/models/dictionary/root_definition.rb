# == Schema Information
#
# Table name: dictionary_root_definitions
#
#  id              :bigint           not null, primary key
#  definition_type :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  word_root_id    :bigint
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
