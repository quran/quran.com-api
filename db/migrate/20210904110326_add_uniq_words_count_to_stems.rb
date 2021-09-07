class AddUniqWordsCountToStems < ActiveRecord::Migration[6.1]
  def change
    add_column :stems, :words_count, :integer
    add_column :stems, :uniq_words_count, :integer

    add_column :roots, :words_count, :integer
    add_column :roots, :uniq_words_count, :integer

    add_column :lemmas, :words_count, :integer
    add_column :lemmas, :uniq_words_count, :integer

    add_column :mushafs, :resource_content_id, :integer
    rename_column :resource_contents, :resource_type, :resource_type_name
    add_column :resource_contents, :resource_type, :string

    add_column :mushaf_pages, :first_word_id, :integer
    add_column :mushaf_pages, :last_word_id, :integer
  end
end
