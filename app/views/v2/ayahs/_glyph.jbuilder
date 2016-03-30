json.resource_id  glyph.resource_id
json.ayah_key     glyph.ayah_key
json.position     glyph.position
json.word_id      glyph.word_id
json.page_num     glyph.page_num
json.line_num     glyph.line_num
json.code_dec     glyph.code_dec
json.code_hex     glyph.code_hex
json.char_type_id glyph.char_type_id
json.class_name   "p#{glyph.char_type_id}"

json.partial! "word", word: glyph.word
