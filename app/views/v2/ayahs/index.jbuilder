json.cache! ['v2', params], expires_in: 12.hours do
  json.partial! "v2/ayahs/ayah", collection: @ayahs, as: :ayah
end
