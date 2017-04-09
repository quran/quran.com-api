class AddSlugToResourceContent < ActiveRecord::Migration[5.0]
  def change
    add_column :resource_contents, :slug, :string
    add_index :resource_contents, :slug
  end
end
