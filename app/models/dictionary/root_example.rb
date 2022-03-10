# frozen_string_literal: true
# == Schema Information
# Schema version: 20220123232023
#
# Table name: dictionary_root_examples
#
#  id                           :bigint           not null, primary key
#  segment_arabic               :string
#  segment_first_word_timestamp :integer
#  segment_last_word_timestamp  :integer
#  segment_translation          :string
#  word_arabic                  :string
#  word_translation             :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  segment_first_word_id        :integer
#  segment_last_word_id         :integer
#  verse_id                     :integer
#  word_id                      :integer
#  word_root_id                 :bigint
#
# Indexes
#
#  index_dictionary_root_examples_on_verse_id  (verse_id)
#  index_dictionary_root_examples_on_word_id   (word_id)
#  index_on_dict_word_example_id               (word_root_id)
#

class Dictionary::RootExample < ApplicationRecord
  belongs_to :word_root, class_name: 'Dictionary::WordRoot'
  belongs_to :word, optional: true
end
