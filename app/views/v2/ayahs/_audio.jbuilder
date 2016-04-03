<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
surah = file.ayah_key.split(':')[0]
ayah = file.ayah_key.split(':')[1]

json.recitation_id file.recitation_id
json.format        file.format
json.duration      file.duration
json.mime_type     file.mime_type
json.url           "http://verses.quran.com/#{file.reciter.path}/#{file.format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{file.format}"

json.reciter       file.reciter
=======
json.file_id       file.file_id
=======
surah = file.ayah_key.split(':')[0]
ayah = file.ayah_key.split(':')[1]

>>>>>>> More changes
json.recitation_id file.recitation_id
json.format        file.format
json.duration      file.duration
json.mime_type     file.mime_type
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
json.is_enabled    file.is_enabled
>>>>>>> New api
=======
json.url           "http://verses.quran.com/#{file.reciter.path}/#{file.format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{file.format}"

json.reciter       file.reciter
>>>>>>> More changes
