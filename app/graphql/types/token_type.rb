Types::TokenType = GraphQL::ObjectType.define do
  name 'Token'

  backed_by_model :token do
    attr :id
    attr :text_madani
    attr :text_clean
    attr :text_indopak
    attr :transliteration

    has_one :word
  end
end
