surah = file.ayah_key.split(':')[0]
ayah = file.ayah_key.split(':')[1]

json.recitation_id file.recitation_id
json.format        file.format
json.duration      file.duration
json.mime_type     file.mime_type
json.url           "http://verses.quran.com/#{file.reciter.path}/#{file.format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{file.format}"

json.reciter       file.reciter
