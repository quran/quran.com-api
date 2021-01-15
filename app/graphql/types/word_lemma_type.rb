module Types
  class WordLemmaType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: true
    field :lemma_id, Integer, null: true
  end
end
