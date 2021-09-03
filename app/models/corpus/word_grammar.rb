# == Schema Information
#
# Table name: corpus_word_grammars
#
#  id         :bigint           not null, primary key
#  position   :integer
#  text       :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint
#
# Indexes
#
#  index_corpus_word_grammars_on_word_id               (word_id)
#  index_corpus_word_grammars_on_word_id_and_position  (word_id,position)
#
class Corpus::WordGrammar < ApplicationRecord
end
