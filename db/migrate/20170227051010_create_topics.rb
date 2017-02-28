class CreateConcepts < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.references :parent

      t.timestamps
    end
  end
end
