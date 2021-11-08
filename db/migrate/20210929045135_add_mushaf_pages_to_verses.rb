class AddMushafPagesToVerses < ActiveRecord::Migration[6.1]
  def change
    create_table :verse_pages do |t|
      t.integer :verse_id, index: true
      t.integer :page_id
      t.integer :page_number
      t.integer :mushaf_id

      t.index [:page_number, :mushaf_id]
    end

    add_column :verses, :mushaf_pages_mapping, :jsonb, default: {}

    add_column :tafsirs, :group_verse_key_from, :string
    add_column :tafsirs, :group_verse_key_to, :string
    add_column :tafsirs, :group_verses_count, :integer
    add_column :tafsirs, :group_tafsir_id, :integer

    add_column :tafsirs, :start_verse_id, :integer
    add_column :tafsirs, :end_verse_id, :integer

    add_index :tafsirs, :start_verse_id
    add_index :tafsirs, :end_verse_id
  end
end