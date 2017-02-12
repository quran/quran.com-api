class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.references :verse
      t.references :resource_content
      t.integer :width
      t.string :url
      t.text :alt

      t.timestamps
    end
  end
end
