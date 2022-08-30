class CreateAyahThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :ayah_themes do |t|
      t.integer :chapter_id, index: true
      t.integer :verse_number_from, index: true
      t.integer :verse_number_to, index: true
      t.string :verse_key_from
      t.string :verse_key_to
      t.integer :verse_id_from, index: true
      t.integer :verse_id_to, index: true
      t.integer :verses_count
      t.string :theme
      t.jsonb :keywords
      t.integer :book_id, index: true

      t.timestamps
    end
  end
end
