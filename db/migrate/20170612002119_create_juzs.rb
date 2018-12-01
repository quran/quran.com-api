class CreateJuzs < ActiveRecord::Migration[5.0]
  def change
    create_table :juzs do |t|
      t.integer :juz_number, index: true
      t.text :verse_mapping

      t.timestamps
    end
  end
end
