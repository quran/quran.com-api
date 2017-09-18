Types::WordRootType = GraphQL::ObjectType.define do
  name 'WordRoot'

  backed_by_model :word_root do
    attr :id
    attr :word_id
    attr :root_id

    has_one :word
  end
end
