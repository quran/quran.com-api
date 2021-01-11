module Types
  class WordStemType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: true
    field :stem_id, Integer, null: true
  end
end
