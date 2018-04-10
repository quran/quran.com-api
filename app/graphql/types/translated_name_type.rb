# frozen_string_literal: true

Types::TranslatedNameType = GraphQL::ObjectType.define do
  name 'TranslatedName'

  backed_by_model :translated_name do
    attr :id
    attr :language_id
    attr :name
    attr :language_name
  end
end
