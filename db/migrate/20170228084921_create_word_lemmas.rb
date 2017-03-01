class CreateWordLemmas < ActiveRecord::Migration[5.0]
  def change
    create_table :word_lemmas do |t|
      t.references :word, foreign_key: true
      t.references :lemma, foreign_key: true

      t.timestamps
    end
  end
end
