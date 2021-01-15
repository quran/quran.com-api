module Types
  class TranslationType < Types::BaseObject
    field :id, ID, null: false
    field :language_id, Integer, null: true
    field :language_name, String, null: true
    field :text, String, null: true
    field :verse_id, Integer, null: true
    field :resource_name, String, null: true
  end
end
