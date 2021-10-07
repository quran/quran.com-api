class CreateCorpusWordForms < ActiveRecord::Migration[6.1]
  def change
    create_table :corpus_word_forms do |t|
      t.belongs_to :word
      t.string :name
      t.string :arabic
      t.string :arabic_simple

      t.timestamps
    end
  end
end
