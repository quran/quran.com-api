json.ayah_index     ayah.ayah_index
json.surah_id       ayah.surah_id
json.ayah_num       ayah.ayah_num
json.page_num       ayah.page_num
json.juz_num        ayah.juz_num
json.hizb_num       ayah.hizb_num
json.rub_num        ayah.rub_num
json.text           ayah.text
json.text_tashkeel  ayah.text_tashkeel if ayah.text_tashkeel
json.ayah_key       ayah.ayah_key
json.sajdah         ayah.sajdah

json.set! :words do
  json.array! ayah.glyphs.sort do |glyph|
    json.resource_id  glyph.resource_id
    json.ayah_key     glyph.ayah_key
    json.position     glyph.position
    json.word_id      glyph.word_id
    json.page_num     glyph.page_num
    json.line_num     glyph.line_num
    json.code_dec     glyph.code_dec
    json.char_type_id glyph.char_type_id
    json.class_name   "p#{glyph.char_type_id}"
    json.code_hex     "&#x#{glyph.code_hex}"

    word = glyph.word
    if word
      json.set! :word do
        json.word_id         word.word_id
        json.ayah_key        word.ayah_key
        json.position        word.position

        json.corpus          word.corpus
        json.token           word.token.value
        json.translation     word.translation.value
        json.transliteration word.transliteration.value
      end
    end
  end
end

json.set! :content do
  json.array! ayah.translations do |content|
    json.resource_id content.resource_id
    json.ayah_key    content.ayah_key
    json.text        content.text

    json.resource    content.resource
  end
end

json.set! :audio do
  mp3 = ayah.audio.find{|file| file.format == 'mp3'}
  ogg = ayah.audio.find{|file| file.format == 'ogg'}

  if mp3
    json.set! :mp3 do
      file = mp3
      surah = file.ayah_key.split(':')[0]
      ayah = file.ayah_key.split(':')[1]

      json.recitation_id file.recitation_id
      json.format        file.format
      json.duration      file.duration
      json.mime_type     file.mime_type
      json.url           "http://verses.quran.com/#{file.reciter.path}/#{file.format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{file.format}"

      json.reciter       file.reciter
    end
  end

  if ogg
    json.set! :ogg do
      file = ogg
      surah = file.ayah_key.split(':')[0]
      ayah = file.ayah_key.split(':')[1]

      json.recitation_id file.recitation_id
      json.format        file.format
      json.duration      file.duration
      json.mime_type     file.mime_type
      json.url           "http://verses.quran.com/#{file.reciter.path}/#{file.format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{file.format}"

      json.reciter       file.reciter
    end
  end
end
