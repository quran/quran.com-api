# frozen_string_literal: true

Types::WordLemmaType = GraphQL::ObjectType.define do
  name 'WordLemma'

  backed_by_model :word_lemma do
    attr :id
    attr :word_id
    attr :lemma_id

    has_one :word
  end
end
