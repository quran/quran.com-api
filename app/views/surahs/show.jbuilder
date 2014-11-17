json.page @surah.page
json.revelation do 
    json.order @surah.revelation_order
    json.place @surah.revelation_place
end
json.name do 
    json.arabic @surah.name_arabic
    json.simple @surah.name_simple
    json.complex @surah.name_complex
    json.english @surah.name_english
end
json.ayat @surah.ayat
json.bismillah_pre @surah.bismillah_pre
json.id @surah["id"].to_i