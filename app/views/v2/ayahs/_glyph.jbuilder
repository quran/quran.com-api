<<<<<<< 737f5ee9dd8b6da932707047067785827520f578
<<<<<<< 3d98ebc8bca07505f1e721078baf7247c529e1b4
=======
>>>>>>> More changes
json.cache! ['v2', glyph], expires_in: 10.minutes do
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
<<<<<<< 737f5ee9dd8b6da932707047067785827520f578

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
