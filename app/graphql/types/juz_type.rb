module Types
  class JuzType < Types::BaseObject
    field :id, ID, null: false
    field :juz_number, Integer, null: true
    field :verse_mapping, GraphQL::Types::JSON, null: true
  end
end
