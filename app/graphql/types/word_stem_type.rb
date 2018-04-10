# frozen_string_literal: true

Types::WordStemType = GraphQL::ObjectType.define do
  name 'WordStem'

  backed_by_model :word_stem do
    attr :id
    attr :word_id
    attr :stem_id

    has_one :word
  end
end
