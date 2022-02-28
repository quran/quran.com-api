# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: dictionary_word_roots
#
#  id                 :integer          not null, primary key
#  frequency          :integer
#  root_number        :integer
#  english_trilateral :string
#  arabic_trilateral  :string
#  cover_url          :string
#  description        :text
#  root_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
