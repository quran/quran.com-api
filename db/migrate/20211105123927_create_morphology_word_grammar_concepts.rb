class CreateMorphologyWordGrammarConcepts < ActiveRecord::Migration[6.1]
  def change
    create_table :morphology_word_grammar_concepts do |t|
      t.belongs_to :word, foreign_key: true
      t.belongs_to :grammar_concept

      t.timestamps
    end
  end
end
