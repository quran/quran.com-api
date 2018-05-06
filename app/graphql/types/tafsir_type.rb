# frozen_string_literal: true

Types::TafsirType = GraphQL::ObjectType.define do
  name 'Tafsir'

  backed_by_model :tafsir do
    attr :id
    attr :verse_id
    attr :language_id
    attr :text
    attr :language_name
    attr :resource_content_id
    attr :resource_name
    attr :verse_key

    has_one :verse
  end
end
