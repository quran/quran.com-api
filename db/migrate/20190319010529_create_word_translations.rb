class CreateWordTranslations < ActiveRecord::Migration[5.2]
  def change
   create_table :word_translations do |t|
     t.integer :word_id
     t.string :text
     t.string :language_name
     t.integer :language_id
     t.integer :resource_content_id
     t.integer :priority, index: true

     t.timestamps
    end

   add_index :word_translations, [:word_id, :language_id]
  end
end
