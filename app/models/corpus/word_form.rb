# == Schema Information
#
# Table name: corpus_word_forms
#
#  id            :bigint           not null, primary key
#  arabic        :string
#  arabic_simple :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  word_id       :bigint
#
# Indexes
#
#  index_corpus_word_forms_on_word_id  (word_id)
#
class Corpus::WordForm < ApplicationRecord
end
