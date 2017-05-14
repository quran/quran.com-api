class AddVerseKeyToTafsirs < ActiveRecord::Migration[5.0]
  def change
    add_column :tafsirs, :verse_key, :string
    add_index :tafsirs, :verse_key
  end
end
