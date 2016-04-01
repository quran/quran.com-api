<<<<<<< afa9d95eaf166e33279c8db904eb2a97efa7face
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
json.cache! ['v2', @surah], expires_in: 3.days do
  json.partial! "v2/surahs/surah", surah: @surah
end
=======
json.partial! "surah", surah: @surah
>>>>>>> New api
=======
json.cache! ['v2', @surah], expires_in: 10.minutes do
  json.partial! "v2/surahs/surah", surah: @surah
end
>>>>>>> Surah cache
