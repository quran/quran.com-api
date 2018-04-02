# frozen_string_literal: true

Types::CharTypeType = GraphQL::ObjectType.define do
  name "CharType"

  backed_by_model :char_type do
    attr :id
    attr :name
    attr :parent_id
    attr :description

    has_one :word
  end
end
