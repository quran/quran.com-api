module Types
  class VerseLemmaType < Types::BaseObject
    field :id, ID, null: false
    field :text_madani, String, null: true
    field :text_clean, String, null: true
  end
end
