<<<<<<< 0daab56b49222b8724395de80f35403847c57888
json.cache! ['v2', @surah], expires_in: 3.days do
  json.partial! "v2/surahs/surah", surah: @surah
end
=======
json.partial! "surah", surah: @surah
>>>>>>> New api
