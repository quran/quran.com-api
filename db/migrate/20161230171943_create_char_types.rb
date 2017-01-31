class CreateCharTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :char_types do |t|
      t.string :name
      t.references :parent
      t.text :description

      t.timestamps
    end
  end
end
