<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
<<<<<<< 0daab56b49222b8724395de80f35403847c57888
<<<<<<< 3d98ebc8bca07505f1e721078baf7247c529e1b4
json.cache! ['v2', params], expires_in: 12.hours do
  json.partial! "v2/ayahs/ayah", collection: @ayahs, as: :ayah
end
=======
json.partial! "ayah", collection: @ayahs, as: :ayah
>>>>>>> WIP
=======
json.cache! ['v2', params], expires_in: 10.minutes do
=======
json.cache! ['v2', params], expires_in: 12.hours do
>>>>>>> More changes
  json.partial! "v2/ayahs/ayah", collection: @ayahs, as: :ayah
end
>>>>>>> New api
