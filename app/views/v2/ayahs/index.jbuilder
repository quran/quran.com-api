<<<<<<< 3d98ebc8bca07505f1e721078baf7247c529e1b4
json.cache! ['v2', params], expires_in: 12.hours do
  json.partial! "v2/ayahs/ayah", collection: @ayahs, as: :ayah
end
=======
json.partial! "ayah", collection: @ayahs, as: :ayah
>>>>>>> WIP
