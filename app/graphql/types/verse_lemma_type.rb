Types::VerseLemmaType = GraphQL::ObjectType.define do
  name 'VerseLemma'

  backed_by_model :verse_lemma do
    attr :id
    attr :text_madani
    attr :text_clean

    has_many_array :verses
  end
end
