class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.string :text_madani
      t.string :text_clean
      t.string :text_indopak
      t.string :transliteration

      t.timestamps
    end
  end
end
