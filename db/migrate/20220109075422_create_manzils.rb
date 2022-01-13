class CreateManzils < ActiveRecord::Migration[6.1]
  def change
    create_table :manzils do |t|
      t.integer :manzil_number
      t.integer :verses_count
      t.json :verse_mapping
      t.integer :first_verse_id
      t.integer :last_verse_id

      t.timestamps
    end
    add_index :manzils, :manzil_number
    add_index :manzils, [:first_verse_id, :last_verse_id]

    [:translations, :tafsirs, :audio_files, :verses].each do |table|
      add_column table, :manzil_number, :integer
      add_index table, :manzil_number
    end
  end
end
