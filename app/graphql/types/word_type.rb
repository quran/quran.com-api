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
    has_one :word_corpus

    has_many_array :word_lemmas
    has_many_array :lemmas
    has_many_array :word_stems
    has_many_array :stems
    has_many_array :word_roots
    has_many_array :roots
    
    field :otherVerses, types[types.String] do
      resolve ->(word, _args, _ctx) { Word.where(text_simple: word.text_simple).pluck(:verse_key) }
    end

    field :occurance, types.Int do
      resolve ->(word, _args, _ctx) { Word.where(text_simple: word.text_simple).count }
    end
  end
end
