# frozen_string_literal: true

module Types
  class RootType < Types::BaseObject
    field :id, ID, null: false
    field :value, String, null: true
  end
end
