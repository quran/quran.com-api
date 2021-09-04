class AddUniqWordsCountToStems < ActiveRecord::Migration[6.1]
  def change
    add_column :stems, :words_count, :integer
    add_column :stems, :uniq_words_count, :integer

    add_column :roots, :words_count, :integer
    add_column :roots, :uniq_words_count, :integer

    add_column :lemmas, :words_count, :integer
    add_column :lemmas, :uniq_words_count, :integer
  end
end
