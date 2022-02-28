# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_word_grammar_concepts
#
#  id                 :integer          not null, primary key
#  word_id            :integer
#  grammar_concept_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_morphology_word_grammar_concepts_on_grammar_concept_id  (grammar_concept_id)
#  index_morphology_word_grammar_concepts_on_word_id             (word_id)
#

class Morphology::WordGrammarConcept < ApplicationRecord
  belongs_to :word, class_name: 'Morphology::Word'
  belongs_to :grammar_concept, class_name: 'Morphology::GrammarConcept'
end
