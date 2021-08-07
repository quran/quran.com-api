class CreateQuranDictionaryWordRoots < ActiveRecord::Migration[6.1]
  def change
    create_table :dictionary_word_roots do |t|
      t.integer :frequency
      t.integer :root_number
      t.string :english_trilateral
      t.string :arabic_trilateral
      t.string :cover_url
      t.text :description
      t.integer :root_id

      t.index :root_id
      t.index :root_number
      t.index :arabic_trilateral
      t.index :english_trilateral

      t.timestamps
    end
  end
end
