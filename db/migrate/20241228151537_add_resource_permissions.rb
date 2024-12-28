class AddResourcePermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :resource_contents, :permission_to_host, :integer, default: 0
    add_column :resource_contents, :permission_to_share, :integer, default: 0
  end
end
