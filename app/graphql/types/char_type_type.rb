# frozen_string_literal: true

module Types
  class CharTypeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :parent_id, Integer, null: true
    field :description, String, null: true
  end
end
