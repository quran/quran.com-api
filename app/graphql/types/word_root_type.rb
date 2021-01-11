module Types
  class WordRootType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: true
    field :root_id, Integer, null: true
  end
end
