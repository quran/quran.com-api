class CreateRecitations < ActiveRecord::Migration[5.0]
  def change
    create_table :recitations do |t|
      t.references :reciter
      t.references :resource_content
      t.references :recitation_style
      t.string :reciter_name # cache
      t.string :style

      t.timestamps
    end
  end
end
