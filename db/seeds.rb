unless Rails.env.production?
  connection = ActiveRecord::Base.connection

  ActiveRecord::Base.logger = Logger.new( STDOUT )
  ActiveRecord::Base.transaction do
    connection.execute <<-SQL
      ALTER TABLE audio.file
        DROP CONSTRAINT _file_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE audio.file
        DROP CONSTRAINT _file_recitation_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE audio.recitation
        DROP CONSTRAINT recitation_reciter_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE audio.recitation
        DROP CONSTRAINT recitation_style_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.tafsir_ayah
        DROP CONSTRAINT _tafsir_ayah_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.tafsir_ayah
        DROP CONSTRAINT _tafsir_ayah_tafsir_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.translation
        DROP CONSTRAINT _translation_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.transliteration
        DROP CONSTRAINT _transliteration_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.resource_api_version
        DROP CONSTRAINT resource_api_version_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.resource
        DROP CONSTRAINT resource_author_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.resource
        DROP CONSTRAINT resource_language_code_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.resource
        DROP CONSTRAINT resource_source_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.tafsir
        DROP CONSTRAINT tafsir_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.translation
        DROP CONSTRAINT translation_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE content.transliteration
        DROP CONSTRAINT transliteration_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.ayah
        DROP CONSTRAINT ayah_surah_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.char_type
        DROP CONSTRAINT char_type_parent_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.image
        DROP CONSTRAINT image_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.image
        DROP CONSTRAINT image_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.text
        DROP CONSTRAINT text_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.text
        DROP CONSTRAINT text_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_translation
        DROP CONSTRAINT translation_language_code_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_translation
        DROP CONSTRAINT translation_word_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word
        DROP CONSTRAINT word_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_font
        DROP CONSTRAINT word_font_ayah_key_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_font
        DROP CONSTRAINT word_font_char_type_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_font
        DROP CONSTRAINT word_font_resource_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_font
        DROP CONSTRAINT word_font_word_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_lemma
        DROP CONSTRAINT word_lemma_lemma_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_lemma
        DROP CONSTRAINT word_lemma_word_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_root
        DROP CONSTRAINT word_root_root_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_root
        DROP CONSTRAINT word_root_word_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_stem
        DROP CONSTRAINT word_stem_stem_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word_stem
        DROP CONSTRAINT word_stem_word_id_fkey
    SQL
    connection.execute <<-SQL
      ALTER TABLE quran.word
        DROP CONSTRAINT word_token_id_fkey
    SQL

    Rake::Task['db:data:load_dir'].invoke()

    connection.execute <<-SQL
      ALTER TABLE ONLY audio.file
        ADD CONSTRAINT _file_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY audio.file
        ADD CONSTRAINT _file_recitation_id_fkey FOREIGN KEY (recitation_id) REFERENCES recitation(recitation_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY audio.recitation
        ADD CONSTRAINT recitation_reciter_id_fkey FOREIGN KEY (reciter_id) REFERENCES reciter(reciter_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY audio.recitation
        ADD CONSTRAINT recitation_style_id_fkey FOREIGN KEY (style_id) REFERENCES style(style_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.tafsir_ayah
        ADD CONSTRAINT _tafsir_ayah_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.tafsir_ayah
        ADD CONSTRAINT _tafsir_ayah_tafsir_id_fkey FOREIGN KEY (tafsir_id) REFERENCES tafsir(tafsir_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.translation
        ADD CONSTRAINT _translation_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.transliteration
        ADD CONSTRAINT _transliteration_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.resource_api_version
        ADD CONSTRAINT resource_api_version_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.resource
        ADD CONSTRAINT resource_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(author_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.resource
        ADD CONSTRAINT resource_language_code_fkey FOREIGN KEY (language_code) REFERENCES i18n.language(language_code) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.resource
        ADD CONSTRAINT resource_source_id_fkey FOREIGN KEY (source_id) REFERENCES source(source_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.tafsir
        ADD CONSTRAINT tafsir_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.translation
        ADD CONSTRAINT translation_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY content.transliteration
        ADD CONSTRAINT transliteration_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.ayah
        ADD CONSTRAINT ayah_surah_id_fkey FOREIGN KEY (surah_id) REFERENCES surah(surah_id)
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.char_type
        ADD CONSTRAINT char_type_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES char_type(char_type_id) ON UPDATE CASCADE ON DELETE SET NULL
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.image
        ADD CONSTRAINT image_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.image
        ADD CONSTRAINT image_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.text
        ADD CONSTRAINT text_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.text
        ADD CONSTRAINT text_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_translation
        ADD CONSTRAINT translation_language_code_fkey FOREIGN KEY (language_code) REFERENCES i18n.language(language_code) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_translation
        ADD CONSTRAINT translation_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word
        ADD CONSTRAINT word_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_font
        ADD CONSTRAINT word_font_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_font
        ADD CONSTRAINT word_font_char_type_id_fkey FOREIGN KEY (char_type_id) REFERENCES char_type(char_type_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_font
        ADD CONSTRAINT word_font_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_font
        ADD CONSTRAINT word_font_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE SET NULL
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_lemma
        ADD CONSTRAINT word_lemma_lemma_id_fkey FOREIGN KEY (lemma_id) REFERENCES lemma(lemma_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_lemma
        ADD CONSTRAINT word_lemma_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_root
        ADD CONSTRAINT word_root_root_id_fkey FOREIGN KEY (root_id) REFERENCES root(root_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_root
        ADD CONSTRAINT word_root_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_stem
        ADD CONSTRAINT word_stem_stem_id_fkey FOREIGN KEY (stem_id) REFERENCES stem(stem_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word_stem
        ADD CONSTRAINT word_stem_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
    connection.execute <<-SQL
      ALTER TABLE ONLY quran.word
        ADD CONSTRAINT word_token_id_fkey FOREIGN KEY (token_id) REFERENCES token(token_id) ON UPDATE CASCADE ON DELETE CASCADE
    SQL
  end
end
