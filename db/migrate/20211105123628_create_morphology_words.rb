class CreateMorphologyWords < ActiveRecord::Migration[6.1]
  def change
    rename_table :corpus_morphology_terms, :morphology_grammar_terms

    create_table :morphology_words do |t|
      t.belongs_to :word, foreign_key: true
      t.belongs_to :verse, foreign_key: true
      t.belongs_to :grammar_pattern
      t.belongs_to :grammar_base_pattern

      t.integer :words_count_for_root
      t.integer :words_count_for_lemma
      t.integer :words_count_for_stem

      t.string :location
      t.text :description
      t.string :case
      t.string :case_reason

      t.timestamps
    end

    add_index :morphology_words, :location
  end
end