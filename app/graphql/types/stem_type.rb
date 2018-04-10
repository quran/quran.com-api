# frozen_string_literal: true

Types::StemType = GraphQL::ObjectType.define do
  name 'Stem'

  backed_by_model :stem do
    attr :id
    attr :text_madani
    attr :text_clean
  end
end
