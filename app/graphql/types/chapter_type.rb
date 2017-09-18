Types::ChapterType = GraphQL::ObjectType.define do
  name 'Chapter'

  backed_by_model :chapter do
    attr :id
    attr :bismillah_pre
    attr :revelation_order
    attr :revelation_place
    attr :name_complex
    attr :name_arabic
    attr :name_simple
    attr :verses_count
    attr :chapter_number

    has_many_connection :verses

    field :pages, types[types.Int] do
      resolve ->(chapter, _args, _ctx) { chapter.pages }
    end

    field :translatedName, Types::TranslatedNameType do
      argument :language, types.String, default_value: 'en'
      
      resolve ->(chapter, args, _ctx) do
        chapter.translated_name
      end
    end

    field :chapterInfo, Types::ChapterInfoType do
      argument :language, types.String, default_value: 'en'
      
      resolve ->(chapter, args, _ctx) do
        chapter.chapter_infos.filter_by_language_or_default(args[:language])
      end
    end
  end
end
