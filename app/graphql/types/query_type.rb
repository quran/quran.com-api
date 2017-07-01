Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  
  field :chapters, types[Types::ChapterType] do
    resolve ->(_obj, _args, _ctx) { Chapter.all }
  end

  field :chapter, Types::ChapterType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Chapter.find(args[:id]) }
  end

  field :verses, types[Types::VerseType] do
    argument :chapter_id, !types.ID
    resolve ->(_obj, args, _ctx) { Verse.where(chapter_id: args[:chapter_id]) }
  end

  field :verse, Types::VerseType do
    argument :id, types.ID
    argument :key, types.String
    resolve lambda { |_obj, args, _ctx|
      return Verse.find(args[:id]) if args[:id]

      Verse.find_by_verse_key(args[:key])
    }
  end

  field :tafsirs, types[Types::TafsirType] do
    argument :verse_id, types.ID
    argument :verse_key, types.String
    resolve lambda { |_obj, args, _ctx|
      return Tafsir.where(verse_id: args[:verse_id]) if args[:verse_id]

      Tafsir.where(verse_key: args[:verse_key])
    }
  end

  field :tafsir, Types::TafsirType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Tafsir.find(args[:id]) }
  end

  field :words, types[Types::WordType] do
    argument :verse_id, types.ID
    argument :verse_key, types.String
    resolve lambda { |_obj, args, _ctx|
      return Word.where(verse_id: args[:verse_id]) if args[:verse_id]

      Word.where(verse_key: args[:verse_key])
    }
  end

  field :word, Types::WordType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Word.find(args[:id]) }
  end
end
