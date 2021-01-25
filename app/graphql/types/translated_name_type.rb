# frozen_string_literal: true

module Types
  class TranslatedNameType < Types::BaseObject
    field :id, ID, null: false
    field :language_id, Integer, null: true
    field :name, String, null: false
    field :language_name, String, null: true
  end
end
