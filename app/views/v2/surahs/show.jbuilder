json.cache! ['v2', @surah], expires_in: 3.days do
  json.partial! "v2/surahs/surah", surah: @surah
end
