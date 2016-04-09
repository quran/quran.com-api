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

  json.partial! "v2/ayahs/word", word: glyph.word if glyph.word
end
