# == Schema Information
#
# Table name: dictionary_word_roots
#
#  id                 :bigint           not null, primary key
#  arabic_trilateral  :string
#  cover_url          :string
#  description        :text
#  english_trilateral :string
#  frequency          :integer
#  root_number        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  root_id            :integer
#
# Indexes
#
#  index_dictionary_word_roots_on_arabic_trilateral   (arabic_trilateral)
#  index_dictionary_word_roots_on_english_trilateral  (english_trilateral)
#  index_dictionary_word_roots_on_root_id             (root_id)
#  index_dictionary_word_roots_on_root_number         (root_number)
#
class Dictionary::WordRoot < ApplicationRecord
  belongs_to :root, optional: true
  has_many :root_examples, class_name: 'Dictionary::RootExample'
  has_many :root_definitions, class_name: 'Dictionary::RootDefinition'

  accepts_nested_attributes_for :root_examples, allow_destroy: true
  accepts_nested_attributes_for :root_definitions, allow_destroy: true
end
