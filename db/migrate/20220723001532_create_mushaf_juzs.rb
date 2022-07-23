class CreateMushafJuzs < ActiveRecord::Migration[7.0]
  def change
    create_table :mushaf_juzs do |t|
      t.integer :mushaf_type, index: true
      t.integer :mushaf_id, index: true
      t.integer :juz_id, index: true
      t.jsonb :verse_mapping
      t.integer :juz_number, index: true
      t.integer :verses_count
      t.integer :first_verse_id, index: true
      t.integer :last_verse_id, index: true

      t.timestamps
    end

    add_column :verses, :mushaf_juzs_mapping, :jsonb, default: {}
  end
end
