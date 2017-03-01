class CreateVerseLemmas < ActiveRecord::Migration[5.0]
  def change
    create_table :verse_lemmas do |t|
      t.string :text_madani
      t.string :text_clean

      t.timestamps
    end

    add_column :verses, :verse_lemma_id, :integer
    add_index :verses, :verse_lemma_id
  end
end
