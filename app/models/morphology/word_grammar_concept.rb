# == Schema Information
#
# Table name: morphology_word_grammar_concepts
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  grammar_concept_id :bigint
#  word_id            :bigint
#
# Indexes
#
#  index_morphology_word_grammar_concepts_on_grammar_concept_id  (grammar_concept_id)
#  index_morphology_word_grammar_concepts_on_word_id             (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
class Morphology::WordGrammarConcept < ApplicationRecord
  belongs_to :word, class_name: 'Morphology::Word'
  belongs_to :grammar_concept, class_name: 'Morphology::GrammarConcept'
end
