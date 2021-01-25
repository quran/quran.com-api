# frozen_string_literal: true

module Types
  class TafsirType < Types::BaseObject
    field :id, ID, null: false
    field :verse_id, Integer, null: true
    field :language_id, Integer, null: true
    field :text, String, null: true
    field :language_name, String, null: true
    field :resource_content_id, Integer, null: true
    field :resource_name, String, null: true
    field :verse_key, String, null: true
  end
end
