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

    language = Language.find_by_iso_code('en')
    arabic_lang = Language.find_by_iso_code('ar')


    #Migrate resource, authors
    author = Author.where(name: 'King Fahd Quran Printing Complex',  url: 'http://www.qurancomplex.org/').first_or_create
    r = Quran::WordFont.first.resource
    ResourceContent.where(name: r.name, author: author, language: language).first_or_create(author_name: author.name, cardinality_type: r.cardinality_type, resource_type: r.type, sub_type: r.sub_type, description: r.description)

    Content::Resource.find_each do |content|
      author = Author.where(name: content.author.name, url: content.author.url).first_or_create if content.author
      resource_content = ResourceContent.where(author: author, resource_type: content.type, sub_type: content.sub_type, name: content.name, cardinality_type: content.cardinality_type).first_or_create
      resource_content.description = content.description
      resource_content.language = Language.find_by_iso_code(content.language_code)
      resource_content.author_name = author&.name
      resource_content.save
    end

    ResourceContent.update_all approved: true

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

      puts "chapter #{chapter.id}"

      chapter.translated_names.where(language: Language.find_by_iso_code('en')).first_or_create.update_attributes name: surah.name_english
    end

    #Chapter info
    author = Author.where(name: "Tafhim al-Qur'an", url: "http://www.tafheem.net/").first_or_create
    resource_content =  ResourceContent.where(name: "Chapter Info", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: 'chapter-info', resource_type: 'Quran', sub_type: 'Chapter')
    resource_content.approved = true
    resource_content.description = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
    resource_content.save

    Content::SurahInfo.find_each do |info|
      chapter_info = ChapterInfo.where(language: language, chapter_id: info.surah_id).first_or_create
      chapter_info.short_text = info.short_description
      chapter_info.text = info.description
      chapter_info.source = info.content_source
      chapter_info.resource_content = resource_content

      puts "verse info #{chapter_info.id}"

      chapter_info.save
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
      puts "verse #{verse.id}"
    end

    Verse.order('verse_number asc').each do |verse|
      Quran::WordFont.where(ayah_key: verse.verse_key).order('position asc').each do |word_font|
        word = Word.where(verse_id: verse.id, position: word_font.position).first_or_initialize
        char_type = CharType.where(name: word_font.char_type.name).first_or_create

        if word_font.char_type.parent
          char_type.parent = CharType.where(name: word_font.char_type.parent.name).first_or_create
        end
        char_type.description = word_font.char_type.description
        char_type.save

        word.page_number = word_font.page_num
        word.line_number = word_font.line_num
        word.code_dec = word_font.code_dec
        word.code_hex = word_font.code_hex
        word.char_type_id = char_type.id
        word.verse_key = verse.verse_key
        word.save
        puts "word #{word.id}"
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

    #Tafsir
    Content::TafsirAyah.order('').each do |tafsir|
      resource = tafsir.tafsir.resource
      language = Language.find_by_iso_code(resource.language_code)
      verse = Verse.find_by_verse_key(tafsir.ayah_key)

      resource_content = ResourceContent.where(resource_type: resource.type, sub_type: resource.sub_type, author_name: resource.author&.name, cardinality_type: resource.cardinality_type).first
      taf = verse.tafsirs.where(language: language, resource_content: resource_content).first_or_create(text: tafsir.tafsir.text )
      puts "ayah tafsir #{taf.id}"
    end

    #verse Translations
    Content::Translation.order('').each do |trans|
      resource = trans.resource
      language = Language.find_by_iso_code(resource.language_code)
      verse = Verse.find_by_verse_key(trans.ayah_key)

      resource_content = ResourceContent.where(resource_type: resource.type, sub_type: resource.sub_type, author_name: resource.author&.name, cardinality_type: resource.cardinality_type).first
      translation = verse.translations.where(language: language, resource_content: resource_content).first_or_create(text: trans.text )

      puts "ayah translation #{translation.id}"
    end

    #verse Transliteration
    Content::Transliteration.order('').each do |trans|
      resource = trans.resource
      language = Language.find_by_iso_code(resource.language_code) || language
      verse = Verse.find_by_verse_key(trans.ayah_key)

      resource_content = ResourceContent.where(resource_type: resource.type, sub_type: resource.sub_type, author_name: resource.author&.name, cardinality_type: resource.cardinality_type).first
      transliteration = verse.transliterations.where(language: language, resource_content: resource_content).first_or_create(text: trans.text )

      puts "ayah transliterations #{transliteration.id}"
    end

    # create author and resource content for Bayyinah
    media_resource = Media::Resource.first

    author = Author.where(name: media_resource.name,  url: media_resource.url).first_or_create
    resource_content = ResourceContent.where(author: author, language: language).first_or_create(author_name: author.name, cardinality_type: '1_ayah_video', approved: true)
    #Migrate media content
    Media::Content.all.each do |media|
      verse = Verse.find_by_verse_key(media.ayah_key)
      verse.media_contents.where(url: media.url, resource_content_id: resource_content.id).first_or_create
    end

    #Migrate audio files
    Audio::Style.find_each do |style|
      s = RecitationStyle.where(style: style.english).first_or_create
      s.translated_names.where(language: arabic_lang).first_or_create(name: style.arabic)
      s.translated_names.where(language: language).first_or_create(name: style.english)
    end

    Audio::Reciter.find_each do |r|
      reciter = Reciter.where(name: r.english).first_or_create
      reciter.translated_names.where(language: arabic_lang).first_or_create(name: r.arabic)
      reciter.translated_names.where(language: language).first_or_create(name: r.english)
    end

    Audio::Recitation.find_each do |r|
      resource_content = ResourceContent.where(language: arabic_lang, author_name: r.reciter.english).first_or_create(cardinality_type: '1_ayah_audio')
      style = RecitationStyle.find_by_style(r.style.english) if r.style
      Recitation.where(resource_content: resource_content, reciter:  Reciter.find_by_name(r.reciter.english), recitation_style: style).first_or_create

      resource_content.approved = Audio::File.where(recitation_id: r.id, is_enabled: false).blank?
      resource_content.save
    end

    Audio::File.find_each do |file|
      reciter = Reciter.find_by_name(file.reciter.english)
      recitation_style = RecitationStyle.find_by_style(file.recitation.style.english) if file.recitation.style
      recitation = Recitation.where(reciter: reciter, recitation_style: recitation_style).first
      verse = Verse.find_by_verse_key(file.ayah_key)

      audio = AudioFile.where(resource: verse, recitation: recitation).first_or_create
      audio.segments = file.segments
      audio.url = file.url
      audio.duration = file.duration
      audio.mime_type = file.mime_type
      audio.format = file.format
      audio.save

      puts "audio #{audio.id}"
    end
  end
end

# Update content resource for image rename table to image

