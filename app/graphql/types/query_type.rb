Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  
  field :chapters, types[Types::ChapterType] do
    resolve ->(_obj, _args, _ctx) { Chapter.all }
  end

  field :chapter, Types::ChapterType do
    argument :id, !types.ID
    resolve ->(_obj, args, _ctx) { Chapter.find(args[:id]) }
  end

  field :chapterInfo, Types::ChapterInfoType do
    argument :chapterId, !types.ID
    argument :language, types.String, default_value: 'en'
    resolve ->(_obj, args, _ctx) { 
      ChapterInfo.where(chapter_id: args[:chapterId]).filter_by_language_or_default(args[:language])
    }
  end

  field :verses, types[Types::VerseType] do
    argument :chapterId, !types.ID
    argument :language, types.String, default_value: 'en'
    argument :offset, types.Int, default_value: 0
    argument :padding, types.Int, default_value: 0
    argument :page, types.Int, default_value: 1
    argument :limit, types.Int, default_value: 10, prepare: ->(limit, ctx) {
      limit <= 50 ? limit : 50
    }
    resolve ->(_obj, args, _ctx) {
      eager_words = [
        "#{args[:language]}_translations".to_sym,
        "#{args[:language]}_transliterations".to_sym
      ]

      Verse
      .where(chapter_id: args[:chapterId])
      .preload(:media_contents, words: eager_words)
      .page(args[:page])
      .per(args[:limit])
      .offset(args[:offset])
      .padding(args[:padding])
    }
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
    argument :verseId, types.ID
    argument :verseKey, types.String
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
    argument :verseId, types.ID
    argument :verseKey, types.String
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
