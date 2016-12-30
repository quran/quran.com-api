namespace :v3 do
  task import_from_v2: :environment do
    #Migrate languages
    Locale::Language.find_each do |l|
      language = Language.find_or_initialize_by(name: l.english.to_s.strip)

      language.iso_code = l.language_code.to_s.strip
      language.native_name = l.unicode.to_s.strip
      language.direction = l.direction.to_s.strip
      language.es_analyzer_default = l.es_analyzer_default.to_s.strip
      language.save
    end

    #Migrate chapters
    Quran::Surah.order('surah_id asc').each do |surah|
      chapter = Chapter.find_or_initialize_by(chapter_number: surah.id)

      chapter.bismillah_pre = surah.bismillah_pre
      chapter.revelation_place = surah.revelation_place
      chapter.revelation_order = surah.revelation_order
      chapter.pages = surah.page
      chapter.name_complex = surah.name_complex
      chapter.name_arabic = surah.name_arabic
      chapter.save

      chapter.translated_names.where(language: Language.find_by_iso_code('en')).first_or_create.update_attributes name: surah.name_english
    end

    #Migrate verses
    Quran::Ayah.order("surah_id asc, ayah_num asc").each do |ayah|
      verse = Verse.find_or_initialize_by(verse_key: ayah.ayah_key)

      verse.chapter_id = ayah.surah_id
      verse.page_number = ayah.page_num
      verse.juz_number = ayah.juz_num
      verse.hizb_number = ayah.hizb_num
      verse.rub_number = ayah.rub_num
      verse.sajdah = ayah.sajdah
      verse.verse_number = ayah.ayah_num

      verse.text_simple = ayah.text
      verse.text_madani = Quran::Text.find_by_ayah_key(ayah.ayah_key).text
      verse.save
    end

    language = Language.find_by_iso_code('en')
    Verse.order('verse_number asc').each do |verse|
      Quran::WordFont.where(ayah_key: verse.verse_key).order('position asc').each do |word_font|
        word = Word.where(verse_id: verse.id, position: word_font.position).first_or_initialize

        word.page_number = word_font.page_num
        word.line_number = word_font.line_num
        word.code_dec = word_font.code_dec
        word.code_hex = word_font.code_hex
        word.char_type_id = word_font.char_type_id
        word.verse_key = verse.verse_key
        word.save

        if word_font.word
          if token = word_font.word.token
            word.text_madani =token.value
            word.text_simple =token.clean
          end

          word.translations.where(language: language).first_or_create(text: word_font.word.translation)
          word.transliterations.where(language: language).first_or_create(text: word_font.word.transliteration)
        end
      end
    end

    # create author and resource content for Bayyinah
    media_resource = Media::Resource.first

    author = Author.where(name: media_resource.name,  url: media_resource.url).first_or_create
    resource_content = ResourceContent.where(author: author, language: language).first_or_create(cardinality_type: '1_ayah_video')
    #Migrate media content
    Media::Content.all.each do |media|
      verse = Verse.find_by_verse_key(media.ayah_key)
      verse.media_contents.where(url: media.url, resource_content_id: resource_content.id).first_or_create
    end
  end
end
