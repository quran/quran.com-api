class CreateCorpusMorphologyTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :corpus_morphology_terms do |t|
      t.string :category, index: true
      t.string :term, index: true
      t.string :arabic_grammar_name #TODO: Create language specific table for storing grammar
      t.string :english_grammar_name
      t.string :urdu_grammar_name

      t.text :arabic_description
      t.text :english_description
      t.text :urdu_description

      t.timestamps
    end

    add_column :mushafs, :qirat_type_id, :integer
    add_column :mushafs, :enabled, :boolean
    add_index :mushafs, :enabled
    add_index :mushafs, :qirat_type_id
  end
end
