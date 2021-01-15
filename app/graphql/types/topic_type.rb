module Types
  class TopicType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :parent_id, Integer, null: true
  end
end
