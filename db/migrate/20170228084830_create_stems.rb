class CreateStems < ActiveRecord::Migration[5.0]
  def change
    create_table :stems do |t|
      t.string :text_madani
      t.string :text_clean

      t.timestamps
    end
  end
end
