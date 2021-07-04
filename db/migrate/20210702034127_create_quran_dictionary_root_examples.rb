class CreateQuranDictionaryRootExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :dictionary_root_examples do |t|
      t.string :word_arabic
      t.string :word_translation
      t.string :segment_arabic
      t.string :segment_translation

      t.integer :segment_first_word_id
      t.integer :segment_last_word_id
      t.integer :segment_first_word_timestamp
      t.integer :segment_last_word_timestamp

      t.integer :word_id

      t.references :word_root, index: { name: :index_on_dict_word_example_id }
      t.index :word_id

      t.timestamps
    end
  end
end
