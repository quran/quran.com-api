# frozen_string_literal: true

Types::VerseRootType = GraphQL::ObjectType.define do
  name "VerseRoot"

  backed_by_model :verse_root do
    attr :id
    attr :value

    # has_one :verse
  end
end
