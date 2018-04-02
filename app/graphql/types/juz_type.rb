# frozen_string_literal: true

Types::JuzType = GraphQL::ObjectType.define do
  name "Juz"

  backed_by_model :juz do
    attr :juz_number
    attr :name_simple
    attr :name_arabic
  end

  field :verseMapping, Types::JSONType do
    resolve ->(juz, _args, _ctx) { juz.verse_mapping_before_type_cast }
  end
end
