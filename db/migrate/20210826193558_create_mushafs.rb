class CreateMushafs < ActiveRecord::Migration[7.0]
  def change
    create_table :mushafs do |t|
      t.string :name, null: :false
      t.text :description
      t.integer :lines_per_page
      t.boolean :is_default, default: false, index: true
      t.string :default_font_name
      t.references :resource_content

      t.timestamps
    end
  end
end
