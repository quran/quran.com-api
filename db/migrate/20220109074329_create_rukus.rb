class CreateRukus < ActiveRecord::Migration[6.1]
  def change
    create_table :rukus do |t|
      t.integer :ruku_number
      t.integer :surah_ruku_number
      t.json :verse_mapping
      t.integer :verses_count
      t.integer :first_verse_id
      t.integer :last_verse_id

      t.timestamps
    end

    add_index :rukus, :ruku_number
    add_index :rukus, [:first_verse_id, :last_verse_id]
    add_column :chapters, :rukus_count, :integer

    [:translations, :tafsirs, :audio_files, :verses].each do |table|
      add_column table, :ruku_number, :integer
      add_column table, :surah_ruku_number, :integer

      add_index table, :ruku_number
    end
  end
end