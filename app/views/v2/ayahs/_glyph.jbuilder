<<<<<<< 4b5c5d1bcf6bb8cc92ed1247f6bfe11b75e09a5a
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
<<<<<<< 3d98ebc8bca07505f1e721078baf7247c529e1b4
=======
>>>>>>> More changes
=======
class_name = nil
word_ids.each do |array|
  array.last.split(' ').each do |id|
    class_name = array.first if id == glyph.word_id.to_s
  end
end

>>>>>>> WIP
json.cache! ['v2', glyph], expires_in: 10.minutes do
  json.resource_id  glyph.resource_id
  json.ayah_key     glyph.ayah_key
  json.position     glyph.position
  json.word_id      glyph.word_id
  json.page_num     glyph.page_num
  json.line_num     glyph.line_num
  json.code_dec     glyph.code_dec
  json.char_type_id glyph.char_type_id
<<<<<<< 4b5c5d1bcf6bb8cc92ed1247f6bfe11b75e09a5a
  json.class_name   "p#{glyph.char_type_id}"
  json.code_hex     "&#x#{glyph.code_hex}"
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
=======
  json.class_name   glyph.class_name
  json.code         glyph.code

  json.highlight    class_name if class_name
>>>>>>> WIP

  json.partial! "v2/ayahs/word", word: glyph.word if glyph.word
end
=======
json.resource_id  glyph.resource_id
json.ayah_key     glyph.ayah_key
json.position     glyph.position
json.word_id      glyph.word_id
json.page_num     glyph.page_num
json.line_num     glyph.line_num
json.code_dec     glyph.code_dec
json.char_type_id glyph.char_type_id
json.class_name   "p#{glyph.char_type_id}"
json.code_hex     "&#x#{glyph.code_hex}"

<<<<<<< 0daab56b49222b8724395de80f35403847c57888
json.partial! "word", word: glyph.word
>>>>>>> WIP
=======
json.partial! "v2/ayahs/word", word: glyph.word if glyph.word
>>>>>>> New api
=======

  json.partial! "v2/ayahs/word", word: glyph.word if glyph.word
end
>>>>>>> More changes
