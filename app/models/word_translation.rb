# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: word_translations
#
#  id                  :integer          not null, primary key
#  word_id             :integer
#  text                :string
#  language_name       :string
#  language_id         :integer
#  resource_content_id :integer
#  priority            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_word_translations_on_priority                 (priority)
#  index_word_translations_on_word_id_and_language_id  (word_id,language_id)
#

class WordTranslation < ApplicationRecord
  include Resourceable

  belongs_to :word
  belongs_to :language
end
