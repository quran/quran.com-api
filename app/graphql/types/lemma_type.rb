# frozen_string_literal: true

Types::LemmaType = GraphQL::ObjectType.define do
  name "Lemma"

  backed_by_model :lemma do
    attr :id
    attr :text_madani
    attr :text_clean
  end
end
