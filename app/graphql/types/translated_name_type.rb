module Types
  class TranslatedNameType < Types::BaseObject
    field :id, ID, null: false
    field :resource_type, String, null: true
    field :resource_id, Integer, null: true
    field :language_id, Integer, null: true
    field :name, String, null: true
    field :language_name, String, null: true
  end
end
