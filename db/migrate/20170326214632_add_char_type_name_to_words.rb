class AddCharTypeNameToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :char_type_name, :string
  end
end
