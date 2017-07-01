Types::WordType = GraphQL::ObjectType.define do
  name 'Word'

  backed_by_model :word do
    attr :id
    attr :verse_id
    attr :chapter_id
    attr :position
    attr :text_madani
    attr :text_indopak
    attr :text_simple
    attr :verse_key
    attr :page_number
    attr :class_name
    attr :line_number
    attr :code_dec
    attr :code_hex
    attr :code_hex_v3
    attr :code_dec_v3
    attr :char_type_id
    attr :pause_name
    attr :audio_url
    attr :image_blob
    attr :image_url
    attr :location
    attr :topic_id
    attr :token_id
    attr :char_type_name

    has_one :verse
  end
end
