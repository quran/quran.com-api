class CreateResourceTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, index: true
      t.string :description

      t.timestamps
    end

    create_table :resource_tags do |t|
      t.integer :tag_id
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end

    add_index :resource_tags, [:tag_id, :resource_id, :resource_type], name: 'index_on_resource_tag'
  end
end
