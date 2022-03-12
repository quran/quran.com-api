class CreateRoots < ActiveRecord::Migration[5.0]
  def change
    create_table :roots do |t|
      t.string :text_clean, index: true
      t.string :text_uthmani, index: true
      t.string :english_trilateral, index: true
      t.string :arabic_trilateral, index: true
      t.string :dictionary_image_path

      t.json :en_translations
      t.json :ur_translations

      t.timestamps
    end
  end
end
