# frozen_string_literal: true

Types::TranslationType = GraphQL::ObjectType.define do
  name "Translation"

  backed_by_model :translation do
    attr :id
    attr :language_id
    attr :text
    attr :resource_content_id
    attr :resource_type
    attr :resource_id
    attr :language_name
    attr :resource_name
  end
end
