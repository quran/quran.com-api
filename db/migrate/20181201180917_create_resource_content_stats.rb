class CreateResourceContentStats < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_content_stats do |t|
      t.references :resource_content
      t.integer :download_count
      t.string :platform, index: true # could be ios, or android

      t.timestamps
    end

    add_column :translated_names, :language_priority, :integer
    add_index :translated_names, :language_priority
  end
end
