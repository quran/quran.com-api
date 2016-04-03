<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
<<<<<<< afa9d95eaf166e33279c8db904eb2a97efa7face
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
json.cache! ['v2', @surahs], expires_in: 3.days do
  json.partial! "v2/surahs/surah", collection: @surahs, as: :surah
end
=======
json.partial! "surah", collection: @surahs, as: :surah
>>>>>>> New api
=======
json.cache! ['v2', @surahs], expires_in: 10.minutes do
=======
json.cache! ['v2', @surahs], expires_in: 3.days do
>>>>>>> More changes
  json.partial! "v2/surahs/surah", collection: @surahs, as: :surah
end
>>>>>>> Surah cache
