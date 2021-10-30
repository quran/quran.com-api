class CreateMushafWords < ActiveRecord::Migration[6.1]
  def change
    create_table :mushaf_words do |t|
      t.integer :mushaf_id
      t.integer :word_id
      t.integer :verse_id
      t.string :text
      t.integer :char_type_id
      t.string :char_type_name
      t.integer :line_number
      t.integer :page_number
      t.integer :position_in_verse
      t.integer :position_in_line
      t.integer :position_in_page

      t.index [:mushaf_id, :verse_id, :position_in_page], name: 'index_on_mushaf_word_position'
      t.index [:mushaf_id, :word_id], name: 'index_mushaf_words_on_mushaf_id_and_word_id'
    end
  end
end


