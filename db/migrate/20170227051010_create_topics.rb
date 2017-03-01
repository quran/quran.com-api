class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.references :parent

      t.timestamps
    end

    add_column :words, :topic_id, :integer
    add_index :words, :topic_id
  end
end
