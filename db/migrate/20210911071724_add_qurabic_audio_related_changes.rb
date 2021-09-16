class AddQurabicAudioRelatedChanges < ActiveRecord::Migration[6.1]
  def change
    add_column :recitation_styles, :arabic, :string
    add_column :recitation_styles, :slug, :string
    add_index :recitation_styles, :slug
  end
end