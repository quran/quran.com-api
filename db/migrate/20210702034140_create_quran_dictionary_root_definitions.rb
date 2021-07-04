class CreateQuranDictionaryRootDefinitions < ActiveRecord::Migration[6.1]
  def change
    create_table :dictionary_root_definitions do |t|
      t.integer :definition_type
      t.text :description
      t.references :word_root, index: { name: :index_dict_word_definition }
      t.timestamps
    end
  end
end
