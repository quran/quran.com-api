class CreateWordTranslations < ActiveRecord::Migration[5.2]
  def change
   create_table :word_translations do |t|
     t.integer :word_id
     t.string :text
     t.string :language_name
     t.integer :language_id
     t.integer :resource_content_id
     t.integer :priority, index: true

     t.timestamps
    end

   add_index :word_translations, [:word_id, :language_id]

   add_column :translations, :verse_key, :string
   add_column :translations, :chapter_id, :integer
   add_column :translations, :verse_number, :integer
   add_column :translations, :juz_number, :integer
   add_column :translations, :hizb_number, :integer
   add_column :translations, :rub_number, :integer
   add_column :translations, :page_number, :integer

   add_index :translations, :verse_key
   add_index :translations, [:chapter_id, :verse_number]
   add_index :translations, :chapter_id
   add_index :translations, :juz_number
   add_index :translations, :hizb_number
   add_index :translations, :rub_number
   add_index :translations, :page_number

   add_column :tafsirs, :chapter_id, :integer
   add_column :tafsirs, :verse_number, :integer
   add_column :tafsirs, :juz_number, :integer
   add_column :tafsirs, :hizb_number, :integer
   add_column :tafsirs, :rub_number, :integer
   add_column :tafsirs, :page_number, :integer

   add_index :tafsirs, [:chapter_id, :verse_number]
   add_index :tafsirs, :chapter_id
   add_index :tafsirs, :juz_number
   add_index :tafsirs, :hizb_number
   add_index :tafsirs, :rub_number
   add_index :tafsirs, :page_number

   add_column :audio_files, :verse_key, :string
   add_column :audio_files, :chapter_id, :integer
   add_column :audio_files, :verse_number, :integer
   add_column :audio_files, :juz_number, :integer
   add_column :audio_files, :hizb_number, :integer
   add_column :audio_files, :rub_number, :integer
   add_column :audio_files, :page_number, :integer

   add_index :audio_files, :verse_key
   add_index :audio_files, [:chapter_id, :verse_number]
   add_index :audio_files, :chapter_id
   add_index :audio_files, :juz_number
   add_index :audio_files, :hizb_number
   add_index :audio_files, :rub_number
   add_index :audio_files, :page_number

   add_column :juzs, :first_verse_id, :integer
   add_column :juzs, :last_verse_id, :integer
   add_column :juzs, :verses_count, :integer

   add_column :verses, :code_v1, :string
   add_column :verses, :code_v2, :string

   add_column :words, :code_v1, :string
   add_column :words, :code_v2, :string

   add_column :verses, :v2_page, :integer
   add_column :words, :v2_page, :integer

   add_index :juzs, :first_verse_id
   add_index :juzs, :last_verse_id
  end
end
