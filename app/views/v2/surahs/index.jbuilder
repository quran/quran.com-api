json.cache! ['v2', @surahs], expires_in: 10.minutes do
  json.partial! "v2/surahs/surah", collection: @surahs, as: :surah
end
