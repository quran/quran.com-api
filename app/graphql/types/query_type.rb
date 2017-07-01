Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  
  field :chapters, types[Types::ChapterType] do
    resolve ->(_obj, _args, _ctx) { Chapter.all }
  end

  field :chapter, Types::ChapterType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Chapter.find(args[:id]) }
  end

  field :verses, types[Types::VerseType] do
    resolve ->(_obj, _args, _ctx) { Verse.all }
  end

  field :verse, Types::VerseType do
    argument :id, types.ID
    argument :key, types.String
    resolve ->(_obj, args, _ctx) { args[:id] ? Verse.find(args[:id]) : Verse.find_by_verse_key(args[:key]) }
  end

  field :tafsirs, types[Types::TafsirType] do
    resolve ->(_obj, _args, _ctx) { Tafsir.all }
  end

  field :tafsir, Types::TafsirType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Tafsir.find(args[:id]) }
  end
end
