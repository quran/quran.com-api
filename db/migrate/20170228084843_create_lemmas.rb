class CreateLemmas < ActiveRecord::Migration[5.0]
  def change
    create_table :lemmas do |t|
      t.string :text_madani
      t.string :text_clean

      t.timestamps
    end
  end
end
