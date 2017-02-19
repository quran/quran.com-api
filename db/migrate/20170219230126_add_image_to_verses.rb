class AddImageToVerses < ActiveRecord::Migration[5.0]
  def change
    add_column :verses, :image_url, :text
    add_column :verses, :image_width, :integer

    add_column :words, :pause_name, :string
  end
end
