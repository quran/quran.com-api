# frozen_string_literal: true

Types::VerseStemType = GraphQL::ObjectType.define do
  name 'VerseStem'

  backed_by_model :verse_stem do
    attr :id
    attr :text_madani
    attr :text_clean

    has_many_array :verses
  end
end
