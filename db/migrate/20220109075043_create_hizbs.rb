class CreateHizbs < ActiveRecord::Migration[6.1]
  def change
    create_table :hizbs do |t|
      t.integer :hizb_number
      t.integer :verses_count
      t.jsonb :verse_mapping
      t.integer :first_verse_id
      t.integer :last_verse_id

      t.timestamps
    end
    add_index :hizbs, :hizb_number
    add_index :hizbs, [:first_verse_id, :last_verse_id]
    add_column :chapters, :hizbs_count, :integer

    create_table :rub_el_hizbs do |t|
      t.integer :rub_el_hizb_number
      t.integer :verses_count
      t.json :verse_mapping
      t.integer :first_verse_id
      t.integer :last_verse_id

      t.timestamps
    end

    add_index :rub_el_hizbs, :rub_el_hizb_number
    add_index :rub_el_hizbs, [:first_verse_id, :last_verse_id]
    add_column :chapters, :rub_el_hizbs_count, :integer

    [:translations, :tafsirs, :audio_files, :verses].each do |table|
      rename_column table, :rub_number, :rub_el_hizb_number
    end

    add_index :verses, :rub_el_hizb_number
    add_index :verses, :juz_number
    add_index :verses, :hizb_number
  end
end
