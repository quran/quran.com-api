json.cache! ['v2', @surah], expires_in: 10.minutes do
  json.partial! "v2/surahs/surah", surah: @surah
end
