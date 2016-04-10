json.surah_id surah.surah_id
json.ayat surah.ayat
json.bismillah_pre surah.bismillah_pre
json.revelation_order surah.revelation_order
json.revelation_place surah.revelation_place
json.page surah.page

json.set! "name" do
  json.complex surah.name_complex
  json.simple surah.name_simple
  json.english surah.name_english
  json.arabic surah.name_arabic
end
