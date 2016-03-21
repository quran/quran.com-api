# == Schema Information
#
# Table name: word_transliteration
#
#  transliteration_id :integer          not null, primary key
#  word_id            :integer
#  language_code      :string
#  value              :string
#
# Indexes
#
#  index_quran.word_transliteration_on_word_id  (word_id)
#

require 'rails_helper'

RSpec.describe Quran::WordTransliteration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
