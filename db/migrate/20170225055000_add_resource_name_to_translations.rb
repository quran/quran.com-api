class AddResourceNameToTranslations < ActiveRecord::Migration[5.0]
  def change
    add_column :translations, :resource_name, :string
  end
end
