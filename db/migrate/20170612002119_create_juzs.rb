class CreateJuzs < ActiveRecord::Migration[5.0]
  def change
    create_table :juzs do |t|
      t.integer :juz_number
      t.string :name_simple
      t.string :name_arabic
      t.text :verse_mapping

      t.timestamps
    end
  end
end
