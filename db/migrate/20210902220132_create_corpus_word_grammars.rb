class CreateCorpusWordGrammars < ActiveRecord::Migration[6.1]
  def change
    create_table :corpus_word_grammars do |t|
      t.belongs_to :word
      t.integer :position
      t.string :text
      t.string :type
      t.timestamps
    end

    add_index :corpus_word_grammars, [:word_id, :position]
  end
end
