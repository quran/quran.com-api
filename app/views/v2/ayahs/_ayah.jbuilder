json.ayah_index     ayah.ayah_index
json.surah_id       ayah.surah_id
json.ayah_num       ayah.ayah_num
json.page_num       ayah.page_num
json.juz_num        ayah.juz_num
json.hizb_num       ayah.hizb_num
json.rub_num        ayah.rub_num
json.text           ayah.text
<<<<<<< 4b5c5d1bcf6bb8cc92ed1247f6bfe11b75e09a5a
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
<<<<<<< 3d98ebc8bca07505f1e721078baf7247c529e1b4
json.text_tashkeel  ayah.text_tashkeel if ayah.text_tashkeel
=======
json.text_tashkeel  ayah.text_tashkeel.text if ayah.text_tashkeel
>>>>>>> WIP
json.ayah_key       ayah.ayah_key
json.sajdah         ayah.sajdah

json.set! :words do
  json.partial! "v2/ayahs/glyph", collection: ayah.glyphs.sort, as: :glyph
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
end

json.set! :content do
  json.partial! "v2/ayahs/content", collection: ayah.translations, as: :content
end

json.set! :audio do
  mp3 = ayah.audio.find{|file| file.format == 'mp3'}
  ogg = ayah.audio.find{|file| file.format == 'ogg'}

  json.set! :mp3 do
    json.partial! "v2/ayahs/audio", file: mp3  if mp3
  end
  json.set! :ogg do
    json.partial! "v2/ayahs/audio", file: ogg if ogg
  end
=======
=======
json.text_tashkeel  ayah.text_tashkeel if ayah.text_tashkeel
>>>>>>> New api
json.ayah_key       ayah.ayah_key
json.sajdah         ayah.sajdah

json.set! :words do
  json.partial! "v2/ayahs/glyph", collection: ayah.glyphs, as: :glyph
=======
>>>>>>> More changes
end

json.set! :content do
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
  json.partial! "content", collection: ayah.translations, as: :content
>>>>>>> WIP
=======
  json.partial! "v2/ayahs/content", collection: ayah.translations, as: :content
end

json.set! :audio do
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
  json.partial! "v2/ayahs/audio", collection: ayah.audio, as: :file
>>>>>>> New api
=======
  mp3 = ayah.audio.find{|file| file.format == 'mp3'}
  ogg = ayah.audio.find{|file| file.format == 'ogg'}

  json.set! :mp3 do
    json.partial! "v2/ayahs/audio", file: mp3  if mp3
  end
  json.set! :ogg do
    json.partial! "v2/ayahs/audio", file: ogg if ogg
  end
>>>>>>> More changes
end
