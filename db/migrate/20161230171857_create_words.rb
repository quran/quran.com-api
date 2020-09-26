class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.references :verse
      t.references :chapter
      t.integer :position, index: true
      t.string :text_madani
      t.string :text_indopak
      t.string :text_simple
      t.string :text_imlaei
      t.string :verse_key, index: true
      t.integer :page_number
      t.string :class_name
      t.integer :line_number
      t.integer :code_dec
      t.string :code_hex
      # v3 is changing the code( and fonts ) once api is ready and tested we can remove code_dec and code_hex and rename following column
      t.string :code_hex_v3
      t.integer :code_dec_v3
      t.references :char_type
      t.string :location, index: true
      t.string :audio_url

      t.timestamps
    end
  end
end

