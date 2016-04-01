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
  json.partial! "v2/ayahs/glyph", collection: ayah.glyphs, as: :glyph
end

json.set! :content do
  json.partial! "v2/ayahs/content", collection: ayah.translations, as: :content
end

json.set! :audio do
  json.partial! "v2/ayahs/audio", collection: ayah.audio, as: :file
end
