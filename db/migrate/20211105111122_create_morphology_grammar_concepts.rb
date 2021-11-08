class CreateMorphologyGrammarConcepts < ActiveRecord::Migration[6.1]
  def change
    create_table :morphology_grammar_concepts do |t|
      t.string :english, index: true
      t.string :arabic, index: true

      t.timestamps
    end
  end
end
