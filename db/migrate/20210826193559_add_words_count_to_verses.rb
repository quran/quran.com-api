class AddWordsCountToVerses < ActiveRecord::Migration[6.1]
  def change
    add_column :verses, :words_count, :integer
    add_index :verses, :words_count

    add_column :mushafs, :pages_count, :integer
  end
end
