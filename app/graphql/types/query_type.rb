Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  
  field :chapters, types[Types::ChapterType] do
    argument :language, types.String, default_value: 'en'
    
    resolve ->(_obj, args, _ctx) do
      language = Language.find_by_id_or_iso_code(args[:language])
      chapters = Chapter.includes(:translated_name)

      #eager load translated names to avoid n+1 queries
      chapters.
        where(translated_names: {language_id: language.id}).
        or(
          chapters.
            where(translated_names: {language_id: Language.default.id})
        ).
        order('translated_names.language_priority DESC').
        all
    end
  end
  
  field :juzs, types[Types::JuzType] do
    resolve ->(_obj, _args, _ctx) { Juz.all }
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
      language = Language.find_by_id_or_iso_code(args[:language])
  
      eager_words = [
        :translation,
        :transliteration
      ]

      verses = Verse
                 .where(chapter_id: args[:chapterId])
                 .includes(words: eager_words)
      
      verses
      .where(translations: {language_id: language.id})
      .or(verses.where(translations: {language_id: Language.default.id}))
      .order('translations.language_priority DESC')
      .page(args[:page])
      .per(args[:limit])
      .offset(args[:offset])
      .padding(args[:padding])
    }
  end

  field :verse, Types::VerseType do
    argument :id, types.ID
    argument :verseKey, types.String
    
    resolve lambda { |_obj, args, _ctx|
      return Verse.find_by_verse_key(args[:verseKey]) if args[:verseKey].present?
      Verse.find(args[id])
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

  field :verseTafsir, Types::TafsirType do
    argument :verseKey, !types.String
    argument :tafsirId, !types.ID
    
    resolve lambda { |_obj, args, _ctx| 
      resource_id = ResourceContent
                    .where(id: args[:tafsirId])
                    .or(ResourceContent
                    .where(slug: args[:tafsirId]))
                    .pluck(:id)

      verse = Verse.find_by_id_or_key(args[:verseKey])
      verse.tafsirs.where(resource_content_id: resource_id).first
    }
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

  field :audioFiles, types[Types::AudioFileType] do
    argument :recitationId, !types.ID
    argument :resourceIds, !types[types.ID]
    argument :resourceType, types.String, default_value: 'Verse'
    
    resolve ->(obj, args, _ctx) {
      AudioFile.where(
        resource_id: args[:resourceIds],
        resource_type: args[:resourceType],
        recitation_id: args[:recitationId]
      )
    }
  end

  field :audioFile, Types::AudioFileType do
    argument :recitationId, !types.ID
    argument :resourceId, !types.ID
    argument :resourceType, types.String, default_value: 'Verse'
    
    resolve ->(obj, args, _ctx) {
      AudioFile.where(
        resource_id: args[:resourceId],
        resource_type: args[:resourceType],
        recitation_id: args[:recitationId]
      ).first
    }
  end

  # field :search, [Types::VerseType] do
  #   argument :q, !types.String
  #   argument :page, types.Int, default_value: 1
  #   argument :size, types.Int, default_value: 20
  #   argument :lanugage, types.String, default_value: 'en'
  #   resolve ->(_obj, args, _ctx) {
  #     client = Search::Client.new(
  #       query,
  #       page: page, size: size, lanugage: language
  #     )

  #     response = client.search

  #     {
  #       query: query,
  #       total_count: response.total_count,
  #       took: response.took,
  #       current_page: response.current_page,
  #       total_pages: response.total_pages,
  #       per_page: response.per_page,
  #       results: response.results
  #     }
  #   }
  # end
end


#cc=chapters.joins("LEFT OUTER JOIN(select resource_id, resource_type, language_id, language_name, name from translated_names where(translated_names.language_id = #{language.id} OR translated_names.language_id = #{Language.default.id}) limit 1) c ON c.resource_id = chapters.id AND c.resource_type = 'Chapter'")