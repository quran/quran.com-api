class CreateResourceContentStats < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_content_stats do |t|
      t.references :resource_content
      t.integer :download_count
      t.string :platfrorm, index: true # could be ios, or android

      t.timestamps
    end
  end
end
