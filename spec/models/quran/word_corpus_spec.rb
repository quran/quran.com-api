# == Schema Information
#
# Table name: word_corpus
#
#  corpus_id       :integer          not null, primary key
#  word_id         :integer
#  location        :string
#  description     :string
#  transliteration :string
#  image_src       :string
#  segment         :json
#
# Indexes
#
#  index_quran.word_corpus_on_word_id  (word_id)
#

require 'rails_helper'

RSpec.describe Quran::WordCorpus, type: :model do
end
