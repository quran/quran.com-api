class AddQurabicAudioRelatedChanges < ActiveRecord::Migration[6.1]
  def change
    add_column :recitation_styles, :arabic, :string
    add_column :recitation_styles, :slug, :string
    add_index :recitation_styles, :slug
    add_column :verses, :pause_words_count, :integer, default: 0
    add_column :resource_contents, :sqlite_db, :string
    add_column :resource_contents, :sqlite_db_generated_at, :datetime
  end
end
