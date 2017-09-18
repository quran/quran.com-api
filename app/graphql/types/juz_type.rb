Types::JuzType = GraphQL::ObjectType.define do
  name 'Juz'

  backed_by_model :juz do
    attr :juz_number
  end

  field :verseMapping, Types::JSONType do
    resolve ->(juz, _args, _ctx) { juz.verse_mapping_before_type_cast }
  end
end
